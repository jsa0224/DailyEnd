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
        view.backgroundColor = UIColor(named: Color.main)
        view.layer.cornerRadius = Layout.cornerRadius
        return view
    }()

    private(set) var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Namespace.plusImage), for: .normal)
        button.tintColor = UIColor(named: Color.selected)
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
        stackView.spacing = Layout.spacing
        stackView.distribution = .fill
        return stackView
    }()

    private(set) var titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.textContainerInset = UIEdgeInsets(top: Layout.textContainerInsetTop,
                                                   left: Layout.textContainerInsetLeft,
                                                   bottom: Layout.textContainerInsetBottom,
                                                   right: Layout.textContainerInsetRight)
        textView.layer.borderColor = UIColor(named: Color.main)?.cgColor
        textView.layer.borderWidth = Layout.borderWidth
        textView.layer.cornerRadius = Layout.cornerRadius
        return textView
    }()

    private(set) var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: Layout.textContainerInsetTop,
                                                   left: Layout.textContainerInsetLeft,
                                                   bottom: Layout.textContainerInsetBottom,
                                                   right: Layout.textContainerInsetRight)
        textView.keyboardDismissMode = .onDrag
        textView.setContentHuggingPriority(.init(Layout.contentHuggingPriority),
                                           for: .vertical)
        textView.layer.borderColor = UIColor(named: Color.main)?.cgColor
        textView.layer.borderWidth = Layout.borderWidth
        textView.layer.cornerRadius = Layout.cornerRadius
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
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Layout.topAnchorConstant),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Layout.trailingAnchorConstant),
            dateLabel.bottomAnchor.constraint(equalTo: diaryImageView.topAnchor, constant: Layout.bottomAnchorConstant),

            diaryImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryImageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor,
                                                   constant: Layout.bottomAnchorConstant),
            diaryImageView.widthAnchor.constraint(equalTo: widthAnchor),
            diaryImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor,
                                                   multiplier: Layout.multiplier),

            imageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                         constant: Layout.leadingAnchorConstant),
            imageBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                          constant: Layout.trailingAnchorConstant),
            imageBackgroundView.bottomAnchor.constraint(equalTo: textStackView.topAnchor,
                                                        constant: Layout.bottomAnchorConstant),
            imageBackgroundView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor,
                                                        multiplier: Layout.multiplier),

            registrationButton.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            registrationButton.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),

            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Layout.leadingAnchorConstant),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: Layout.trailingAnchorConstant),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: Layout.bottomAnchorConstant)
        ])
    }

    func configureView(_ item: DiaryItem) {
        dateLabel.text = item.createdAt
    }

    func isHiddenImage(_ boolean: Bool) {
        diaryImageView.isHidden = boolean
        imageBackgroundView.isHidden = !boolean
    }

    private enum Namespace {
        static let plusImage = "plus"
    }

    private enum Layout {
        static let contentHuggingPriority: Float = 1
        static let spacing: CGFloat = 4
        static let textContainerInsetTop: CGFloat = 8
        static let textContainerInsetLeft: CGFloat = 8
        static let textContainerInsetRight: CGFloat = 8
        static let textContainerInsetBottom: CGFloat = 8
        static let topAnchorConstant: CGFloat = 8
        static let leadingAnchorConstant: CGFloat = 8
        static let trailingAnchorConstant: CGFloat = -8
        static let bottomAnchorConstant: CGFloat = -8
        static let multiplier: CGFloat = 0.65
        static let borderWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 6
    }
}
