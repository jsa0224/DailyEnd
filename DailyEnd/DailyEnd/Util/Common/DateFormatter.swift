//
//  DateFormatter.swift
//  Diary
//
//  Created by 정선아 on 2023/04/24.
//

import Foundation

struct DateFormatterManager {
    func formatDate(_ date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
    }
}
