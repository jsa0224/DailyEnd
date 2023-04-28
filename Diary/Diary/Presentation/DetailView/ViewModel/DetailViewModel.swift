//
//  DetailViewModel.swift
//  Diary
//
//  Created by 정선아 on 2023/04/26.
//

import RxSwift

final class DetailViewModel {
    struct Input {
        let didShowView: Observable<Void>
        let didTapDeleteButton: Observable<AlertActionType>
        let didTapBackButton: Observable<Void>
    }

    struct Output {
        let diaryDetailItem: Observable<DiaryItem>
        let deleteAlertAction: Observable<AlertActionType>
        let updateToComplete: Observable<Void>
    }

    private let diaryUseCase: DiaryUseCaseType
    private let diary: Diary

    init(diaryUseCase: DiaryUseCaseType, diary: Diary) {
        self.diaryUseCase = diaryUseCase
        self.diary = diary
    }

    func transform(_ input: Input) -> Output {
        let fetchDiary = input.didShowView
            .withUnretained(self)
            .flatMap { owner, _ in
                owner
                    .diaryUseCase
                    .fetch(with: self.diary.id)
            }

        let diaryItem = fetchDiary
            .map { diary in
                DiaryItem(diary: diary)
            }

        let deleteAlertAction = input.didTapDeleteButton
            .withUnretained(self)
            .map { owner, action in
                if action == .delete {
                    owner
                        .diaryUseCase
                        .delete(owner.diary)
                }

                return action
            }

        let updateToComplete = input.didTapBackButton
            .withUnretained(self)
            .map { owner, _ in
                owner
                    .diaryUseCase
                    .update(owner.diary)
            }

        return Output(diaryDetailItem: diaryItem,
                      deleteAlertAction: deleteAlertAction,
                      updateToComplete: updateToComplete)
    }
}
