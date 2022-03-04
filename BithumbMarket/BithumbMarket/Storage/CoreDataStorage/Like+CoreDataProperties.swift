//
//  Like+CoreDataProperties.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/04.
//
//

import Foundation
import CoreData


extension Like {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Like> {
        return NSFetchRequest<Like>(entityName: "Like")
    }

    @NSManaged public var symbol: String?

}

extension Like : Identifiable {

}
