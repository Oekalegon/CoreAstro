//
//  UMName+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 04/12/2021.
//
//

import Foundation
import CoreData


extension UMName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMName> {
        return NSFetchRequest<UMName>(entityName: "UMName")
    }

    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var object: UMCelestialObject?

}
