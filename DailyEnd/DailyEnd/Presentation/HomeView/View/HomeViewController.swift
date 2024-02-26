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
        let image = UIImage(named: Image.logo)
        navigationItem.titleView = UIImageView(image: image)
        self.view.backgroundColor = UIColor(named: Color.main)
    }

    private func bind() {
        let didShowView = self.rx.viewWillAppear.asObservable()

        let input = HomeViewModel.Input(didShowView: didShowView)
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
            noticeView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                              multiplier: Layout.multiplier),
            noticeView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: Layout.multiplier)
        ])
    }

    private func hideNoticeView() {
        noticeView.removeFromSuperview()
    }

    private enum Layout {
        static let multiplier: CGFloat = 0.5
        static let fractionalWidth: CGFloat = 1.0
        static let fractionalHeight: CGFloat = 1.0
        static let groupSizeFractionalHeight: CGFloat = 0.5
        static let contentInsetsTop: CGFloat = 16
        static let contentInsetsLeading: CGFloat = 16
        static let contentInsetsTrailing: CGFloat = 16
        static let contentInsetsBottom: CGFloat = 16
    }
}

extension HomeViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Layout.fractionalWidth),
                                              heightDimension: .fractionalHeight(Layout.fractionalHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: Layout.contentInsetsTop,
                                                     leading: Layout.contentInsetsLeading,
                                                     bottom: Layout.contentInsetsBottom,
                                                     trailing: Layout.contentInsetsTrailing)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Layout.fractionalWidth),
                                               heightDimension: .fractionalHeight(Layout.groupSizeFractionalHeight))
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
        collectionView.backgroundColor = UIColor(named: Color.main)
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
