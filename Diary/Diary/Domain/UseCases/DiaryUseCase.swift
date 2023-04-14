//
//  DiaryUseCase.swift
//  Diary
//
//  Created by 정선아 on 2023/03/29.
//

import Foundation
import RxSwift

protocol DiaryUseCaseType {
    func fetch() -> Observable<[Diary]>
}

final class DefaultDiaryUseCase: DiaryUseCaseType {
    private let diaryRepository: CoreDataRepository

    init(diaryRepository: CoreDataRepository) {
        self.diaryRepository = diaryRepository
    }

    func fetch() -> Observable<[Diary]> {
        return diaryRepository.fetchDiaryList()
    }


}
