//
//  CoreDataError.swift
//  Diary
//
//  Created by 정선아 on 2023/04/26.
//

import Foundation

enum CoreDataError: LocalizedError {
    case readFail
    case saveFail

    var description: String {
        switch self {
        case .readFail:
            return "저장소를 불러올 수 없습니다."
        case .saveFail:
            return "저장소에 저장할 수 없습니다."
        }
    }
}
