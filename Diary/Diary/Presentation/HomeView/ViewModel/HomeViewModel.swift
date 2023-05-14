//
//  HomeViewModel.swift
//  Diary
//
//  Created by 정선아 on 2023/03/29.
//

import Foundation
import RxSwift

final class HomeViewModel {
    struct Input {
        var didShowView: Observable<Void>
    }

    struct Output {
        var diaryList: Observable<[Diary]>
    }

    private let diaryUseCase: DiaryUseCaseType
    private let mockData = MockData.diary

    init(diaryUseCase: DiaryUseCaseType) {
        self.diaryUseCase = diaryUseCase
    }

    func transform(input: Input) -> Output {
        let diaryList = input.didShowView
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .diaryUseCase
                    .fetch()
            }

        return Output(diaryList: diaryList)
    }
}
