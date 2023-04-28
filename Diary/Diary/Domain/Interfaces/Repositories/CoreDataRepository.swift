//
//  CoreDataRepository.swift
//  Diary
//
//  Created by 정선아 on 2023/03/29.
//

import Foundation
import RxSwift

protocol CoreDataRepository {
    func save(_ diary: Diary)
    func fetchDiaryList() -> Observable<[Diary]>
    func fetchDiary(with id: UUID) -> Observable<Diary>
    func update(_ diary: Diary)
    func delete(_ diary: Diary)
}


