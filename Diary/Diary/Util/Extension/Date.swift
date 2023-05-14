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
        let dateToString = "\(components.year ?? Namespace.zero)\(components.month ?? Namespace.zero)\(components.day ?? Namespace.zero)"

        return dateToString
    }

    private enum Namespace {
        static let zero = 0
    }
}
