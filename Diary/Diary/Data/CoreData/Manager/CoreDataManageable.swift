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
    func fetch(with id: NSManagedObjectID) -> Observable<DiaryDAO>
    func fetchAllEntities() -> Observable<[DiaryDAO]>
    func fetchObjectID(with id: UUID) -> NSManagedObjectID?
    func update(objectID: NSManagedObjectID?, title: String?, body: String?, image: Data?) throws
    func delete(with diary: Diary)
}
