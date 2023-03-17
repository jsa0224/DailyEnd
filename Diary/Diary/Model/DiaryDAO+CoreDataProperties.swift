//
//  Diary+CoreDataProperties.swift
//  
//
//  Created by 정선아 on 2023/03/14.
//
//

import Foundation
import CoreData


extension DiaryDAO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryDAO> {
        return NSFetchRequest<Diary>(entityName: "DiaryDAO")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}
