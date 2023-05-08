//
//  RecordView.swift
//  Diary
//
//  Created by 정선아 on 2023/05/02.
//

import UIKit

final class RecordView: UIView {
    private let dateLabel: DateLabel = {
        let label = DateLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private(set) var diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let imageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.layer.cornerRadius = 6
        return view
    }()

    private(set) var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(named: "selectedColor")
        return button
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

    private(set) var titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.textContainerInset = UIEdgeInsets(top: 8,
                                                   left: 8,
                                                   bottom: 8,
                                                   right: 8)
        textView.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 6
        return textView
    }()

    private(set) var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 8,
                                                   left: 8,
                                                   bottom: 8,
                                                   right: 8)
        textView.keyboardDismissMode = .onDrag
        textView.setContentHuggingPriority(.init(1), for: .vertical)
        textView.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 6
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
        addSubview(dateLabel)
        addSubview(diaryImageView)
        addSubview(imageBackgroundView)
        addSubview(textStackView)

        imageBackgroundView.addSubview(registrationButton)

        textStackView.addArrangedSubview(titleTextView)
        textStackView.addArrangedSubview(bodyTextView)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: diaryImageView.topAnchor, constant: -8),

            diaryImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryImageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -8),
            diaryImageView.widthAnchor.constraint(equalTo: widthAnchor),
            diaryImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.65),

            imageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageBackgroundView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -8),
            imageBackgroundView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.65),

            registrationButton.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            registrationButton.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),

            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configureView(_ item: DiaryItem) {
        dateLabel.text = item.createdAt
    }

    func isHiddenImage(_ boolean: Bool) {
        diaryImageView.isHidden = boolean
        imageBackgroundView.isHidden = !boolean
    }
}
