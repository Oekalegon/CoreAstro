//
//  UMType+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData

extension UMType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMType> {
        return NSFetchRequest<UMType>(entityName: "UMType")
    }

    @NSManaged public var name: String?
    @NSManaged public var objects: NSSet?

}

// MARK: Generated accessors for objects
extension UMType {

    @objc(addObjectsObject:)
    @NSManaged public func addToObjects(_ value: UMCelestialObject)

    @objc(removeObjectsObject:)
    @NSManaged public func removeFromObjects(_ value: UMCelestialObject)

    @objc(addObjects:)
    @NSManaged public func addToObjects(_ values: NSSet)

    @objc(removeObjects:)
    @NSManaged public func removeFromObjects(_ values: NSSet)

}
