//
//  UISearchTextField.swift
//  Diary
//
//  Created by 정선아 on 2023/05/09.
//

import UIKit
import RxSwift

extension UISearchTextField {
    func setDatePicker(_ datePicker: UIDatePicker) {
        self.inputView = datePicker
//        toolBar.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: 44.0)
//        self.inputAccessoryView = toolBar
    }
}
