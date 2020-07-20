//
//  Data+CoreDataProperties.swift
//  
//
//  Created by Balachandar M on 19/07/20.
//
//

import Foundation
import CoreData


extension Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Data> {
        return NSFetchRequest<Data>(entityName: "Data")
    }

    @NSManaged public var titlestring: String?
    @NSManaged public var descriptionstring: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var isImageAvailable: Bool

}
