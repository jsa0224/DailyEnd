//
//  DetailView.swift
//  Diary
//
//  Created by 정선아 on 2023/04/26.
//

import UIKit

class DetailView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    private let dateLabel: TitleLabel = {
        let label = TitleLabel()

        label.translatesAutoresizingMaskIntoConstraints = false
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let textStackView: UIStackView = {
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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
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
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        addSubview(mainStackView)

        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(diaryImageView)
        mainStackView.addArrangedSubview(textStackView)

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(bodyTextView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            diaryImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.65),
        ])
    }

    func configureView(_ item: DiaryItem) {
        dateLabel.text = item.createdAt
        diaryImageView.image = item.image
        titleLabel.text = item.title
        bodyTextView.text = item.body
    }
}
