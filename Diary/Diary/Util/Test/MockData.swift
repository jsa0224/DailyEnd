//
//  MockData.swift
//  Diary
//
//  Created by 정선아 on 2023/04/27.
//

import UIKit

struct MockData {
    static let diary = Diary(id: UUID(),
                             title: "바다에 놀러옴",
                             body: "히히",
                             createdAt: Date(),
                             image: UIImage(named: "바닷가")?.pngData() ?? Data())
}
