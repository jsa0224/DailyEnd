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
    }
}
