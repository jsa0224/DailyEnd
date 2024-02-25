//
//  UIViewController.swift
//  Diary
//
//  Created by 정선아 on 2/23/24.
//

import Foundation
import UIKit

extension UIViewController {
    func addDoneButtonOnKeyboard(textView: UITextView) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                doneToolbar.barStyle = .default

        let barButtonSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneButtonAction(textView: textView))

        let items = [barButtonSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textView.inputAccessoryView = doneToolbar
    }

    func doneButtonAction(textView: UITextView) -> UIAction {
        return UIAction { _ in
            textView.resignFirstResponder()
        }
    }
}

extension UIViewController {
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                doneToolbar.barStyle = .default

        let barButtonSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneButtonAction(textField: textField))

        let items = [barButtonSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
    }

    func doneButtonAction(textField: UITextField) -> UIAction {
        return UIAction { _ in
            textField.resignFirstResponder()
        }
    }
}
