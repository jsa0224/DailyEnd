//
//  HomeViewController.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: UIViewController {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<DiarySection>

    private let viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    private var collectionView: UICollectionView?
    private var dataSource = DataSource { _, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.identifier,
                                                            for: indexPath) as? DiaryCollectionViewCell else {
            return DiaryCollectionViewCell()
        }

        cell.bind(item)

        return cell
    }
    private let noticeView = NoticeView()

    init(viewModel: HomeViewModel, disposeBag: DisposeBag = DisposeBag()) {
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
        configureHierarchy()
        configureDataSource()
        bind()
    }

    private func configureUI() {
        let image = UIImage(named: "logoImage")
        navigationItem.titleView = UIImageView(image: image)
        self.view.backgroundColor = UIColor(named: "mainColor")
    }

    private func bind() {
        let didEnterView = self.rx.viewWillAppear.asObservable()

        let input = HomeViewModel.Input(didEnterView: didEnterView)
        let output = viewModel.transform(input: input)

        guard let collectionView = collectionView else {
            return
        }

        output
            .diaryList
            .withUnretained(self)
            .map { owner, diaries in
                if diaries.isEmpty {
                    self.configureNoticeView()
                } else {
                    self.hideNoticeView()
                }
                return [DiarySection(items: diaries)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(Diary.self)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, diary in
                let coreDataManager = CoreDataManager.shared
                let diaryRepository = DiaryRepository(coreDataManager: coreDataManager)
                let diaryUseCase = DefaultDiaryUseCase(diaryRepository: diaryRepository)
                let detailViewModel = DetailViewModel(diaryUseCase: diaryUseCase,
                                                      diary: diary)
                let detailViewController = DetailViewController(viewModel: detailViewModel)
                owner.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func configureNoticeView() {
        view.addSubview(noticeView)

        NSLayoutConstraint.activate([
            noticeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noticeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noticeView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            noticeView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }

    private func hideNoticeView() {
        noticeView.removeFromSuperview()
    }
}

extension HomeViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        guard let collectionView = collectionView else {
            return
        }

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "mainColor")
        self.view.addSubview(collectionView)
    }

    private func configureDataSource() {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.register(DiaryCollectionViewCell.self,
                                forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier)
    }
}
