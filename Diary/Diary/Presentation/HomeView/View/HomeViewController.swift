//
//  HomeViewController.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Diary>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Diary>

    private let viewModel: HomeViewModel
    private var disposeBag = DisposeBag()
    private var collectionView: UICollectionView?
    private var dataSource: DataSource?
    private var snapshot = SnapShot()

    enum Section {
        case main
    }

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

        output
            .diaryList
            .withUnretained(self)
            .bind(onNext: { owner, diaries in
                owner.makeSnapshot(diaryData: diaries)
            })
            .disposed(by: disposeBag)
    }

    private func makeSnapshot(diaryData: [Diary]) {
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryData)
        dataSource?.apply(snapshot, animatingDifferences: false)
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

        let cellRegistration = UICollectionView.CellRegistration<DiaryCollectionViewCell, Diary> { (cell, indexPath, diary) in
            cell.bind(diary)
        }

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Diary) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}
