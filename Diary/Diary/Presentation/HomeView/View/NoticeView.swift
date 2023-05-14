//
//  NoticeView.swift
//  Diary
//
//  Created by 정선아 on 2023/05/14.
//

import UIKit

final class NoticeView: UIView {
    private let initialNoticeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "저장된 일기가 없습니다." + "\n" + "작성 페이지에서 일기를 추가할 수 있습니다."
        label.numberOfLines = 0
        return label
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
        addSubview(initialNoticeLabel)

        NSLayoutConstraint.activate([
            initialNoticeLabel.topAnchor.constraint(equalTo: topAnchor),
            initialNoticeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            initialNoticeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            initialNoticeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "selectedColor")?.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
