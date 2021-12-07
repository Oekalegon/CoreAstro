//
//  UMArea+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData

extension UMArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMArea> {
        return NSFetchRequest<UMArea>(entityName: "UMArea")
    }

    @NSManaged public var maxDec: Double
    @NSManaged public var maxMagnitude: Double
    @NSManaged public var maxRA: Double
    @NSManaged public var maxSize: Double
    @NSManaged public var minDec: Double
    @NSManaged public var minMagnitude: Double
    @NSManaged public var minRA: Double
    @NSManaged public var minSize: Double
    @NSManaged public var objects: NSOrderedSet?

}

// MARK: Generated accessors for objects
extension UMArea {

    @objc(insertObject:inObjectsAtIndex:)
    @NSManaged public func insertIntoObjects(_ value: UMCelestialObject, at idx: Int)

    @objc(removeObjectFromObjectsAtIndex:)
    @NSManaged public func removeFromObjects(at idx: Int)

    @objc(insertObjects:atIndexes:)
    @NSManaged public func insertIntoObjects(_ values: [UMCelestialObject], at indexes: NSIndexSet)

    @objc(removeObjectsAtIndexes:)
    @NSManaged public func removeFromObjects(at indexes: NSIndexSet)

    @objc(replaceObjectInObjectsAtIndex:withObject:)
    @NSManaged public func replaceObjects(at idx: Int, with value: UMCelestialObject)

    @objc(replaceObjectsAtIndexes:withObjects:)
    @NSManaged public func replaceObjects(at indexes: NSIndexSet, with values: [UMCelestialObject])

    @objc(addObjectsObject:)
    @NSManaged public func addToObjects(_ value: UMCelestialObject)

    @objc(removeObjectsObject:)
    @NSManaged public func removeFromObjects(_ value: UMCelestialObject)

    @objc(addObjects:)
    @NSManaged public func addToObjects(_ values: NSOrderedSet)

    @objc(removeObjects:)
    @NSManaged public func removeFromObjects(_ values: NSOrderedSet)

}
