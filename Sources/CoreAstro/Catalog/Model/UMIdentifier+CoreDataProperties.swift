//
//  UMIdentifier+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 01/12/2021.
//
//

import Foundation
import CoreData


extension UMIdentifier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMIdentifier> {
        return NSFetchRequest<UMIdentifier>(entityName: "Identifier")
    }

    @NSManaged public var attribute: NSObject?
    @NSManaged public var attribute1: NSObject?
    @NSManaged public var identifier: String?
    @NSManaged public var catalog: UMCatalog?
    @NSManaged public var object: UMCelestialObject?

}
