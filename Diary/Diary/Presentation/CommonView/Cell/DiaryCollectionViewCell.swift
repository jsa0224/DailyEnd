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

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()

    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title2)

        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()

        return button
    }()

    private let diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()

        view.contentMode = .scaleAspectFill

        return view
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)

        return label
    }()

    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .body)
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
            .bind(to: bodyTextView.rx.text)
            .disposed(by: disposeBag)

        output?
            .diaryItem
            .observe(on: MainScheduler.instance)
            .map { $0.image }
            .bind(to: diaryImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func configureLayout() {
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(loadingView)
        mainStackView.addArrangedSubview(diaryImageView)
        mainStackView.addArrangedSubview(bottomStackView)

        topStackView.addArrangedSubview(dateLabel)
        topStackView.addArrangedSubview(deleteButton)

        bottomStackView.addArrangedSubview(titleLabel)
        bottomStackView.addArrangedSubview(bodyTextView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            loadingView.heightAnchor.constraint(equalToConstant: 200),
            loadingView.widthAnchor.constraint(equalToConstant: 300),

            diaryImageView.heightAnchor.constraint(equalToConstant: 200),
            diaryImageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

}
