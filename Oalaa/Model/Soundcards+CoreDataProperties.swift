//
//  Soundcards+CoreDataProperties.swift
//  Oalaa
//
//  Created by Steven Wijaya on 26/05/20.
//  Copyright © 2020 M2-911. All rights reserved.
//
//

import Foundation
import CoreData


extension Soundcards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Soundcards> {
        return NSFetchRequest<Soundcards>(entityName: "Soundcards")
    }

    @NSManaged public var soundcardImage: Data?
    @NSManaged public var soundcardName: String?
    @NSManaged public var forCategory: Categories?

}
