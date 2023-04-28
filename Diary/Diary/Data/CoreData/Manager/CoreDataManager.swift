//
//  CoreDataManager.swift
//  Diary
//
//  Created by 정선아 on 2023/03/14.
//

import Foundation
import CoreData
import RxSwift

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

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func generateRequest(by id: UUID) -> NSFetchRequest<DiaryDAO> {
        let request: NSFetchRequest<DiaryDAO> = DiaryDAO.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        return request
    }

    private func fetchResult(from request: NSFetchRequest<DiaryDAO>) -> DiaryDAO? {
        guard let fetchResult = try? context.fetch(request),
              let diaryDAO = fetchResult.first
        else {
            return nil
        }
        return diaryDAO
    }

    func create(with diary: Diary) {
        let request = generateRequest(by: diary.id)

        if let objectToUpdate = fetchResult(from: request) {
            objectToUpdate.title = diary.title
            objectToUpdate.body = diary.body
            objectToUpdate.image = diary.image
        } else {
            let entity = DiaryDAO(context: context)
            entity.id = diary.id
            entity.title = diary.title
            entity.body = diary.body
            entity.image = diary.image
            entity.createdAt = diary.createdAt
        }

        saveContext()
    }

    func fetch(with id: UUID) -> Observable<DiaryDAO> {
        return Observable.create { [weak self] emitter in
            guard let request = self?.generateRequest(by: id),
                  let fetchResult = self?.fetchResult(from: request)
            else {
                emitter.onError(CoreDataError.readFail)
                return Disposables.create()
            }

            emitter.onNext(fetchResult)
            emitter.onCompleted()

            return Disposables.create()
        }
    }

    func fetchAllEntities() -> Observable<[DiaryDAO]> {
        return Observable.create { [weak self] emitter in
            let request = DiaryDAO.fetchRequest()

            guard let diaries = try? self?.context.fetch(request) else {
                return Disposables.create()
            }

            emitter.onNext(diaries)
            emitter.onCompleted()

            return Disposables.create()
        }
    }

    func fetchObjectID(with id: UUID) -> NSManagedObjectID? {
        let fetchRequest = DiaryDAO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: CoreDataNamespace.regex, id.uuidString)

        let result = try? context.fetch(fetchRequest)
        return result?.first?.objectID
    }

    func update(with diary: Diary) {
        let request = generateRequest(by: diary.id)

        guard let objectToUpdate = fetchResult(from: request) else { return }

        objectToUpdate.id = diary.id
        objectToUpdate.title = diary.title
        objectToUpdate.body = diary.body
        objectToUpdate.createdAt = diary.createdAt
        objectToUpdate.image = diary.image

        saveContext()
    }

    func delete(with diary: Diary) {
        let request = generateRequest(by: diary.id)
        guard let objectToDelete = fetchResult(from: request) else { return }
        context.delete(objectToDelete)

        saveContext()
    }

    private enum CoreDataNamespace {
        static let id = "id"
        static let title = "title"
        static let body = "body"
        static let image = "image"
        static let createdAt = "createdAt"
        static let diary = "DiaryDAO"
        static let regex = "id == %@"
        static let loadFailure = "코어 데이터 로드 실패"
    }
}
