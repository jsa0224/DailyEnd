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
        return NSFetchRequest<DiaryDAO>(entityName: "DiaryDAO")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var dateComponents: String?

}

extension DiaryDAO : Identifiable {

}

extension DiaryDAO {
    func toDomain() -> Diary {
        let diary = Diary(id: id ?? UUID(),
                          title: title ?? "",
                          body: body ?? "",
                          createdAt: createdAt ?? Date(),
                          dateComponents: dateComponents ?? "",
                          image: image ?? Data())

        return diary
    }
}
