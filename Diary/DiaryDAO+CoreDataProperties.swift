//
//  DiaryDAO+CoreDataProperties.swift
//  Diary
//
//  Created by 정선아 on 2023/04/11.
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
    @NSManaged public var title: String?
    @NSManaged public var image: Data?

}

extension DiaryDAO : Identifiable {

}

extension DiaryDAO {
    func toDomain() -> Diary {
        let diary = Diary(id: id ?? UUID(),
                          title: title ?? "",
                          body: body ?? "",
                          createdAt: createdAt ?? Date(),
                          image: image ?? Data())

        return diary
    }
}
