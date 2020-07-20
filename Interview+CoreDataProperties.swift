//
//  NetworkManager.swift
//  InterviewTask
//
//  Created by Admin on 19/07/20.
//  Copyright © 2020 Admin. All rights reserved.
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
