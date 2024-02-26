//
//  String.swift
//  Diary
//
//  Created by 정선아 on 2/11/24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}

