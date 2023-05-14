//
//  Date.swift
//  Diary
//
//  Created by 정선아 on 2023/05/12.
//

import Foundation

extension Date {
    func convertDateToString() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let dateToString = "\(components.year ?? 0)\(components.month ?? 0)\(components.day ?? 0)"

        return dateToString
    }
}
