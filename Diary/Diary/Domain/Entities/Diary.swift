//
//  DiaryModel.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import Foundation

struct Diary: Hashable {
    let id: UUID
    var title: String
    var body: String
    let createdAt: Date
    let dateComponents: String
    var image: Data
}
