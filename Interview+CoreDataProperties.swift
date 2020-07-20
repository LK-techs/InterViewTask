//
//  Interview+CoreDataProperties.swift
//  
//
//  Created by Balachandar M on 19/07/20.
//
//

import Foundation
import CoreData


extension Interview {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Interview> {
        return NSFetchRequest<Interview>(entityName: "Interview")
    }

    @NSManaged public var titlestring: String?
    @NSManaged public var descriptionstring: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var isImageAvailable: Bool

}
