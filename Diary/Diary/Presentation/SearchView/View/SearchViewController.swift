//
//  SearchViewController.swift
//  Diary
//
//  Created by 정선아 on 2023/05/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<DiarySection>

    private let viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색할 날짜를 선택해주세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        return searchController
    }()
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        return datePicker
    }()
    private var collectionView: UICollectionView?
    private var dataSource = DataSource { _, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.identifier,
                                                            for: indexPath) as? DiaryCollectionViewCell else {
            return DiaryCollectionViewCell()
        }

        cell.bind(item)

        return cell
    }

    init(viewModel: SearchViewModel, disposeBag: DisposeBag = DisposeBag()) {
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
        handlePicker()
        configureHierarchy()
        configureDataSource()
        bind()
    }

    private func configureUI() {
        let image = UIImage(named: "logoImage")
        navigationItem.titleView = UIImageView(image: image)
        view.backgroundColor = UIColor(named: "mainColor")
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.setDatePicker(datePicker)
    }

    private func handlePicker() {
        let formatter = DateFormatter()
        let pickerAction =  UIAction { _ in
            self.searchController.searchBar.text = formatter.string(from: self.datePicker.date)
            self.searchController.searchBar.searchTextField.resignFirstResponder()
        }

        datePicker.addAction(pickerAction, for: .valueChanged)
    }

    private func bind() {
        let searchDiary = datePicker.rx.value
            .changed
            .asObservable()
            .debug("String")
            .map { $0.convertDateToString() }

        let input = SearchViewModel.Input(didEndSearching: searchDiary)
        let output = viewModel.transform(input)

        guard let collectionView = collectionView else {
            return
        }

        output
            .diary
            .map { diaries in
                if diaries.isEmpty {
                    self.configureAlert()
                }
                return [DiarySection(items: diaries)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    func configureAlert() {
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .default)

        let alert = AlertManager.shared
            .setType(.alert)
            .setTitle("해당 날짜의 일기가 존재하지 않습니다.")
            .setActions([confirmAction])
            .apply()
        self.present(alert, animated: true)
    }
}


extension SearchViewController {
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
