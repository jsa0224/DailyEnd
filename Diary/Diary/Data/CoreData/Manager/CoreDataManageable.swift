//
//  CoreDataManageable.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import Foundation
import CoreData
import RxSwift

protocol CoreDataManageable {
    func create(with diary: Diary)
    func fetchAllEntities() -> Observable<[DiaryDAO]>
    func fetch(with id: UUID) -> Observable<DiaryDAO>
    func update(with diary: Diary)
    func delete(with diary: Diary)
}
