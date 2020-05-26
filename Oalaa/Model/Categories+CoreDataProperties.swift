//
//  Categories+CoreDataProperties.swift
//  Oalaa
//
//  Created by Steven Wijaya on 25/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var categoryImage: Data?
    @NSManaged public var categoryName: String?
    @NSManaged public var installed: Bool
    @NSManaged public var haveSoundcard: NSSet?

}

// MARK: Generated accessors for haveSoundcard
extension Categories {

    @objc(addHaveSoundcardObject:)
    @NSManaged public func addToHaveSoundcard(_ value: Soundcards)

    @objc(removeHaveSoundcardObject:)
    @NSManaged public func removeFromHaveSoundcard(_ value: Soundcards)

    @objc(addHaveSoundcard:)
    @NSManaged public func addToHaveSoundcard(_ values: NSSet)

    @objc(removeHaveSoundcard:)
    @NSManaged public func removeFromHaveSoundcard(_ values: NSSet)

}
