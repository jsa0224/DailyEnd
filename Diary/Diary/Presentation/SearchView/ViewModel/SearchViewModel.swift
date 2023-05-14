//
//  SearchViewModel.swift
//  Diary
//
//  Created by 정선아 on 2023/05/08.
//

import Foundation
import RxSwift

final class SearchViewModel {
    struct Input {
        let didEndSearching: Observable<String>
    }

    struct Output {
        let diary: Observable<[Diary]>
    }

    private let diaryUseCase: DiaryUseCaseType
    private let dateFormatter = DateFormatterManager()

    init(diaryUseCase: DiaryUseCaseType) {
        self.diaryUseCase = diaryUseCase
    }

    func transform(_ input: Input) -> Output {
        let diary = input.didEndSearching
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMap { owner, dateToString in
                owner.diaryUseCase.fetch(with: dateToString)
            }

        return Output(diary: diary)
    }
}
