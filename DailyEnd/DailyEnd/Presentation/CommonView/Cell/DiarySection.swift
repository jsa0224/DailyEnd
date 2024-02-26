//
//  DiarySection.swift
//  Diary
//
//  Created by 정선아 on 2023/04/27.
//

import RxDataSources

struct DiarySection {
    var items: [Diary]
}

extension DiarySection: SectionModelType {
    typealias Item = Diary

    init(original: DiarySection, items: [Diary]) {
        self = original
        self.items = items
    }
}
