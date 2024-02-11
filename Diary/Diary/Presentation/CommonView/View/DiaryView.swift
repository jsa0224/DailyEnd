//
//  DetailView.swift
//  Diary
//
//  Created by 정선아 on 2023/04/26.
//

import UIKit

final class DiaryView: UIView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Layout.spacing
        stackView.distribution = .fill
        return stackView
    }()
    
    private(set) var dateLabel: DateLabel = {
        let label = DateLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = UIColor(named: Color.text)
        return label
    }()

    private(set) var diaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(named: Color.selected)
        imageView.clipsToBounds = true
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
                                                   left: Layout.textContainerInsetTitleLeft,
                                                   bottom: Layout.textContainerInsetBottom,
                                                   right: Layout.textContainerInsetBottom)
        textView.textColor = UIColor(named: Color.text)
        textView.backgroundColor = UIColor(named: Color.background)
        return textView
    }()

    private(set) var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: Layout.textContainerInsetTop,
                                                   left: Layout.textContainerInsetLeft,
                                                   bottom: Layout.textContainerInsetBottom,
                                                   right: Layout.textContainerInsetBottom)
        textView.keyboardDismissMode = .onDrag
        textView.setContentHuggingPriority(.init(Layout.contentHuggingPriority),
                                           for: .vertical)
        textView.textColor = UIColor(named: Color.text)
        textView.backgroundColor = UIColor(named: Color.background)
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

        textStackView.addArrangedSubview(titleTextView)
        textStackView.addArrangedSubview(bodyTextView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            diaryImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor,
                                                   multiplier: Layout.multiplier),
        ])
    }

    func configureView(_ item: DiaryItem) {
        dateLabel.text = item.createdAt
        diaryImageView.image = item.image
        titleTextView.text = item.title
        bodyTextView.text = item.body
    }

    func isEditingTextView(_ boolean: Bool) {
        titleTextView.isEditable = boolean
        bodyTextView.isEditable = boolean
    }

    private enum Layout {
        static let contentHuggingPriority: Float = 1
        static let spacing: CGFloat = 4
        static let textContainerInsetTop: CGFloat = 8
        static let textContainerInsetLeft: CGFloat = 8
        static let textContainerInsetTitleLeft: CGFloat = 7
        static let textContainerInsetRight: CGFloat = 8
        static let textContainerInsetBottom: CGFloat = 8
        static let multiplier: CGFloat = 0.65
    }
}
