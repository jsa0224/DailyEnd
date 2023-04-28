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

    func save(_ diary: Diary) {
        coreDataManager.create(with: diary)
    }

    func fetchDiaryList() -> Observable<[Diary]> {
        return coreDataManager.fetchAllEntities()
            .map {
                $0.map { $0.toDomain() }
            }
    }

    func fetchDiary(with id: UUID) -> Observable<Diary> {
        return coreDataManager.fetch(with: id)
            .map { $0.toDomain() }
    }

    func update(_ diary: Diary) {
        coreDataManager.update(with: diary)
    }

    func delete(_ diary: Diary) {
        coreDataManager.delete(with: diary)
    }
}
