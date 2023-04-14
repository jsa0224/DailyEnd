//
//  DiaryRepository.swift
//  Diary
//
//  Created by 정선아 on 2023/03/29.
//

import Foundation
import RxSwift

final class DiaryRepository: CoreDataRepository {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func fetchDiaryList() -> Observable<[Diary]> {
        return coreDataManager.fetchAllEntities()
            .map {
                $0.map { $0.toDomain() }
            }
    }
}
