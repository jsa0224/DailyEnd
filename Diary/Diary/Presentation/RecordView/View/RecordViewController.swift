//
//  RecordViewController.swift
//  Diary
//
//  Created by 정선아 on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa

final class RecordViewController: UIViewController {
    private let recordView = RecordView()
    private let viewModel: RecordViewModel
    private var disposeBag = DisposeBag()
    private let saveButton: UIBarButtonItem = {
        let saveImage = UIImage(systemName: "checkmark.circle")
        let barButtonItem = UIBarButtonItem(image: saveImage,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        barButtonItem.tintColor = UIColor(named: "mainColor")
        return barButtonItem
    }()

    init(viewModel: RecordViewModel, disposeBag: DisposeBag = DisposeBag()) {
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
        configureImagePicker()
    }

    private func configureUI() {
        let image = UIImage(named: "logoImage")
        navigationItem.titleView = UIImageView(image: image)
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = UIColor(named: "mainColor")

        view.addSubview(recordView)

        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            recordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            recordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            recordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        recordView.backgroundColor = .white
        recordView.layer.cornerRadius = 16
        recordView.clipsToBounds = true
        recordView.isHiddenImage(true)
    }

    private func bind() {
        let didShowViewEvent = Observable.just(())
        let didTapSaveButton = saveButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                if owner.recordView.titleTextView.text == "" || owner.recordView.bodyTextView.text == "" {
                    self.configureAlert()
                }
                return (owner.recordView.titleTextView.text,
                        owner.recordView.bodyTextView.text,
                        owner.recordView.diaryImageView.image?.pngData())
            }

        let input = RecordViewModel.Input(didShowView: didShowViewEvent,
                                          didTapSaveButton: didTapSaveButton)
        let output = viewModel.transform(input)

        output
            .diaryItem
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, item in
                owner.recordView.configureView(item)
            })
            .disposed(by: disposeBag)

        output
            .popRecordViewTrigger
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                self.recordView.titleTextView.text = nil
                self.recordView.bodyTextView.text = nil
                self.recordView.diaryImageView.image = nil
                self.recordView.isHiddenImage(true)
                self.tabBarController?.selectedIndex = 0
            })
            .disposed(by: disposeBag)
    }
}

extension RecordViewController {
    func configureAlert() {
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .default)

        let alert = AlertManager.shared
            .setType(.alert)
            .setTitle("빈 일기장은 저장되지 않습니다.")
            .setActions([confirmAction])
            .apply()
        self.present(alert, animated: true)
    }
}

extension RecordViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func configureImagePicker() {
        let buttonAction = UIAction { [weak self] _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true

            self?.present(imagePicker, animated: true, completion: nil)
        }

        recordView.registrationButton.addAction(buttonAction, for: .touchUpInside)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.recordView.diaryImageView.image = image
            self.recordView.isHiddenImage(false)
        }
    }
}
