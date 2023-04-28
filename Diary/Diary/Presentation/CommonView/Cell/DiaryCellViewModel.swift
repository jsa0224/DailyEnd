//
//  DiaryCellViewModel.swift
//  Diary
//
//  Created by 정선아 on 2023/04/04.
//

import Foundation
import RxSwift

final class DiaryCellViewModel {
    struct Input {
        var didEnterCell: Observable<Diary>
    }

    struct Output {
        var diaryItem: Observable<DiaryItem>
    }

    func transform(input: Input) -> Output {
        let diary = input.didEnterCell
            .withUnretained(self)
            .map { owner, diary in
                DiaryItem(diary: diary)
            }

        return Output(diaryItem: diary)
    }
}
