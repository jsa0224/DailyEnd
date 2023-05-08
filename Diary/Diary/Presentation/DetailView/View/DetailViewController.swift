//
//  DetailViewController.swift
//  Diary
//
//  Created by 정선아 on 2023/04/26.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let diaryDetailView = DiaryView()
    private let viewModel: DetailViewModel
    private var disposeBag = DisposeBag()
    private let deleteButton: UIBarButtonItem = {
        let deleteImage = UIImage(systemName: "trash.circle")
        let barButtonItem = UIBarButtonItem(image: deleteImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = UIColor(named: "mainColor")
        return barButtonItem
    }()

    private let backButton: UIBarButtonItem = {
        let modifyImage = UIImage(systemName: "arrow.backward")
        let barButtonItem = UIBarButtonItem(image: modifyImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = UIColor(named: "mainColor")
        return barButtonItem
    }()

    init(viewModel: DetailViewModel, disposeBag: DisposeBag = DisposeBag()) {
        self.viewModel = viewModel
        self.disposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    private func configureUI() {
        let image = UIImage(named: "logoImage")
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = deleteButton

        view.backgroundColor = UIColor(named: "mainColor")

        view.addSubview(diaryDetailView)

        NSLayoutConstraint.activate([
            diaryDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            diaryDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            diaryDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            diaryDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        diaryDetailView.backgroundColor = .white
        diaryDetailView.layer.cornerRadius = 16
        diaryDetailView.clipsToBounds = true
    }

    private func bind() {
        let didShowView = self.rx.viewWillAppear.asObservable()
        let didTapDeleteButton = deleteButton.rx.tap
            .withUnretained(self)
            .flatMap { owner, _ in
                self.showDeleteAlert()
            }
        let didTapBackButton = backButton.rx.tap.asObservable()

        let input = DetailViewModel.Input(didShowView: didShowView,
                                          didTapDeleteButton: didTapDeleteButton,
                                          didTapBackButton: didTapBackButton)
        let output = viewModel.transform(input)

        output.diaryDetailItem
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                owner.diaryDetailView.configureView(item)
            })
            .disposed(by: disposeBag)

        output.deleteAlertAction
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, action in
                switch action {
                case .delete:
                    self.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        output.updateToComplete
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension DetailViewController {
    func showDeleteAlert() -> Observable<AlertActionType> {
        return Observable.create { [weak self] emitter in
            let cancelAction = UIAlertAction(title: "취소",
                                             style: .cancel) { _ in
                emitter.onNext(.cancel)
                emitter.onCompleted()
            }

            let deleteAction = UIAlertAction(title: "삭제",
                                             style: .destructive) { _ in
                emitter.onNext(.delete)
                emitter.onCompleted()
            }

            let alert = AlertBuilder.shared
                .setType(.alert)
                .setTitle("해당 일기장을 삭제하시겠습니까?")
                .setMessage("삭제할 경우, 데이터가 영구적으로 삭제됩니다.")
                .setActions([cancelAction, deleteAction])
                .apply()

            self?.navigationController?.present(alert, animated: true)

            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
}
