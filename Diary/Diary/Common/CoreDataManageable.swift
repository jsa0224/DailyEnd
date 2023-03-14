//
//  CoreDataManageable.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import Foundation
import CoreData

protocol CoreDataManageable {
    func insert(with id: UUID) throws
    func fetch(with id: NSManagedObjectID?) -> Diary?
    func fetchAllEntities() throws -> [Diary]
    func fetchObjectID(with id: UUID) -> NSManagedObjectID?
    func update(objectID: NSManagedObjectID?, title: String?, body: String?, weatherMain: String?, weatherIcon: String?) throws
    func delete(with id: NSManagedObjectID?) throws
}
