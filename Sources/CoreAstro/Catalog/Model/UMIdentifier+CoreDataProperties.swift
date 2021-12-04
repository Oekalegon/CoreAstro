//
//  UMIdentifier+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData

extension UMIdentifier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMIdentifier> {
        return NSFetchRequest<UMIdentifier>(entityName: "UMIdentifier")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var catalog: UMCatalog?
    @NSManaged public var object: UMCelestialObject?

}
