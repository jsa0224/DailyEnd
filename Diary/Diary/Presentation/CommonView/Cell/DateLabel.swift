//
//  TitleLabel.swift
//  Diary
//
//  Created by 정선아 on 2023/04/24.
//

import UIKit

class DateLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 8.0)

    convenience init(padding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 8.0)) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
