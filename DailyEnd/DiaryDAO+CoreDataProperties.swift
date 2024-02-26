//
//  DiaryDAO+CoreDataProperties.swift
//  Diary
//
//  Created by 정선아 on 2023/05/13.
//
//

import Foundation
import CoreData


extension DiaryDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryDAO> {
        return NSFetchRequest<DiaryDAO>(entityName: Namespace.entityName)
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var dateComponents: String?

    private enum Namespace {
        static let entityName = "DiaryDAO"
    }
}

extension DiaryDAO : Identifiable {

}

extension DiaryDAO {
    func toDomain() -> Diary {
        let diary = Diary(id: id ?? UUID(),
                          title: title ?? Description.emptyString,
                          body: body ?? Description.emptyString,
                          createdAt: createdAt ?? Date(),
                          dateComponents: dateComponents ?? Description.emptyString,
                          image: image ?? Data())

        return diary
    }
}
