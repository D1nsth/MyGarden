//
//  Plant+CoreDataProperties.swift
//  MyGarden
//
//  Created by Никита on 28.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var kind: String?
    @NSManaged public var descriptionPlant: String?
    @NSManaged public var images: Data?

}
