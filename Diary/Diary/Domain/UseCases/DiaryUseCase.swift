//
//  DiaryUseCase.swift
//  Diary
//
//  Created by 정선아 on 2023/03/29.
//

import Foundation
import RxSwift

protocol DiaryUseCaseType {
    func save(_ diary: Diary)
    func fetch() -> Observable<[Diary]>
    func delete(_ diary: Diary)
}

final class DefaultDiaryUseCase: DiaryUseCaseType {
    private let diaryRepository: CoreDataRepository

    init(diaryRepository: CoreDataRepository) {
        self.diaryRepository = diaryRepository
    }

    func save(_ diary: Diary) {
        diaryRepository.save(diary)
    }

    func fetch() -> Observable<[Diary]> {
        return diaryRepository.fetchDiaryList()
    }

    func delete(_ diary: Diary) {
        return diaryRepository.delete(diary)
    }


}
