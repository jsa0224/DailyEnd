//
//  CoreDataManager.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import Foundation
import CoreData

final class CoreDataManager: CoreDataManageable {
    static let shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataNamespace.diary)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard error == nil else {
                return
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: CoreDataNamespace.diary, in: context)
    }

    private init() { }

    func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func insert(with id: UUID) throws {
        guard let diaryEntity = diaryEntity else { return }

        let managedObject = NSManagedObject(entity: diaryEntity, insertInto: context)
        managedObject.setValue(id, forKey: CoreDataNamespace.id)
        managedObject.setValue(Date(), forKey: CoreDataNamespace.createdAt)
        try saveContext()
    }

    func fetch(with id: NSManagedObjectID?) -> DiaryDAO? {
        guard let id = id else { return nil }

        return context.object(with: id) as? DiaryDAO
    }

    func fetchAllEntities() throws -> [DiaryDAO] {
        let request = DiaryDAO.fetchRequest()
        return try context.fetch(request)
    }

    func fetchObjectID(with id: UUID) -> NSManagedObjectID? {
        let fetchRequest = DiaryDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataNamespace.regex, id.uuidString)

        let result = try? context.fetch(fetchRequest)
        return result?.first?.objectID
    }

    func update(objectID: NSManagedObjectID?, title: String?, body: String?, weatherMain: String?, weatherIcon: String?) throws {
        guard let objectID = objectID else { return }

        guard let object = context.object(with: objectID) as? DiaryDAO else { return }

        object.setValue(title, forKey: CoreDataNamespace.title)
        object.setValue(body, forKey: CoreDataNamespace.body)
        object.setValue(weatherMain, forKey: "weatherMain")
        object.setValue(weatherIcon, forKey: "weatherIcon")
        try saveContext()
    }

    func delete(with id: NSManagedObjectID?) throws {
        guard let id = id else { return }

        let object = context.object(with: id)
        context.delete(object)
        try saveContext()
    }

    private enum CoreDataNamespace {
        static let id = "id"
        static let title = "title"
        static let body = "body"
        static let createdAt = "createdAt"
        static let diary = "Diary"
        static let regex = "id == %@"
        static let loadFailure = "코어 데이터 로드 실패"
    }
}
