//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by 정선아 on 2023/04/04.
//

import UIKit
import RxSwift

final class DiaryCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    private let dairyView = DiaryView()
    private var viewModel: DiaryCellViewModel?
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        dairyView.diaryImageView.image = nil
        dairyView.titleTextView.text = nil
        dairyView.bodyTextView.text = nil
        disposeBag = DisposeBag()
    }

    func bind(_ diary: Diary) {
        viewModel = DiaryCellViewModel()

        let diary: Observable<Diary> = Observable.just(diary)
        let input = DiaryCellViewModel.Input(didEnterCell: diary)
        let output = viewModel?.transform(input: input)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.title }
            .bind(to: dairyView.titleTextView.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.body }
            .bind(to: dairyView.bodyTextView.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.createdAt }
            .bind(to: dairyView.dateLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.image }
            .bind(to: dairyView.diaryImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func configureLayout() {
        contentView.addSubview(dairyView)

        NSLayoutConstraint.activate([
            dairyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dairyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dairyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dairyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.backgroundColor = UIColor(named: Color.background)
        contentView.layer.cornerRadius = Layout.cornerRadius
        contentView.clipsToBounds = true
        contentView.systemLayoutSizeFitting(.init(width: self.bounds.width, height: self.bounds.height))
        dairyView.isEditingTextView(false)
    }

    private enum Layout {
        static let cornerRadius: CGFloat = 16
    }
}
