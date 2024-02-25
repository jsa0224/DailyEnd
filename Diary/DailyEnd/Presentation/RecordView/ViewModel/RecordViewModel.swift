//
//  RecordViewModel.swift
//  Diary
//
//  Created by 정선아 on 2023/05/02.
//

import Foundation
import RxSwift

final class RecordViewModel {
    struct Input {
        let didShowView: Observable<Void>
        let didTapSaveButton: Observable<(String?, String?, Data?)>
    }

    struct Output {
        let diaryItem: Observable<DiaryItem>
        let popRecordViewTrigger: Observable<Void>
    }

    private let diaryUseCase: DiaryUseCaseType
    private let diary: Diary

    init(diaryUseCase: DiaryUseCaseType, diary: Diary) {
        self.diaryUseCase = diaryUseCase
        self.diary = diary
    }

    func transform(_ input: Input) -> Output {
        let diaryItem = input.didShowView
            .withUnretained(self)
            .map { owner, _ in
                DiaryItem(diary: owner.diary)
            }

        let popRecordViewTrigger = input.didTapSaveButton
            .withUnretained(self)
            .map { owner, data in
                let dataToSave = Diary(id: UUID(),
                                       title: data.0 ?? Description.emptyString,
                                       body: data.1 ?? Description.emptyString,
                                       createdAt: Date(),
                                       dateComponents: Date().convertDateToString(),
                                       image: data.2 ?? Data())
                if dataToSave.title != Description.emptyString || dataToSave.body != Description.emptyString {
                    owner.diaryUseCase.save(dataToSave)
                }
            }

        return Output(diaryItem: diaryItem,
                      popRecordViewTrigger: popRecordViewTrigger)
    }

}
