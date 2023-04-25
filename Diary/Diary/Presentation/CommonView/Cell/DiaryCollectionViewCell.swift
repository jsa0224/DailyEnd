//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by 정선아 on 2023/04/04.
//

import UIKit
import RxSwift

final class DiaryCollectionViewCell: UICollectionViewCell {
    private var viewModel: DiaryCellViewModel?
    private var disposeBag = DisposeBag()
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private let dateLabel: TitleLabel = {
        let label = TitleLabel()

        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title2)

        return label
    }()

    private let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private let titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()

    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 8,
                                                   left: 16,
                                                   bottom: 8,
                                                   right: 8)
        textView.keyboardDismissMode = .onDrag
        textView.setContentHuggingPriority(.init(1), for: .vertical)
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        diaryImageView.image = nil
        titleLabel.text = nil
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
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.body }
            .bind(to: bodyTextView.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.createdAt }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.image }
            .bind(to: diaryImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func configureLayout() {
        contentView.addSubview(topStackView)
//        contentView.addSubview(deleteButton)
        contentView.addSubview(diaryImageView)
        contentView.addSubview(bottomStackView)

        topStackView.addArrangedSubview(dateLabel)

        bottomStackView.addArrangedSubview(titleLabel)
        bottomStackView.addArrangedSubview(bodyTextView)

        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topStackView.bottomAnchor.constraint(equalTo: diaryImageView.topAnchor, constant: -4),

            diaryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            diaryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            diaryImageView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -8),
            diaryImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            diaryImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),

            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.systemLayoutSizeFitting(.init(width: self.bounds.width, height: self.bounds.height))
    }

}
