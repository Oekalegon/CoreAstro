//
//  UMCatalog+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 01/12/2021.
//
//

import Foundation
import CoreData


extension UMCatalog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMCatalog> {
        return NSFetchRequest<UMCatalog>(entityName: "Catalog")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var name: String?
    @NSManaged public var objectIdentifiers: NSSet?

}

// MARK: Generated accessors for objectIdentifiers
extension UMCatalog {

    @objc(addObjectIdentifiersObject:)
    @NSManaged public func addToObjectIdentifiers(_ value: UMIdentifier)

    @objc(removeObjectIdentifiersObject:)
    @NSManaged public func removeFromObjectIdentifiers(_ value: UMIdentifier)

    @objc(addObjectIdentifiers:)
    @NSManaged public func addToObjectIdentifiers(_ values: NSSet)

    @objc(removeObjectIdentifiers:)
    @NSManaged public func removeFromObjectIdentifiers(_ values: NSSet)

}
