//
//  LikedMovie+CoreDataProperties.swift
//  MovieDB
//
//  Created by Damir Yackupov on 12.03.2022.
//
//

import Foundation
import CoreData


extension LikedMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedMovie> {
        return NSFetchRequest<LikedMovie>(entityName: "LikedMovie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isLiked: Bool
    @NSManaged public var currentDate: Date?

}

extension LikedMovie : Identifiable {

}
