//
//  UMCelestialObject+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 01/12/2021.
//
//

import Foundation
import CoreData


extension UMCelestialObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMCelestialObject> {
        return NSFetchRequest<UMCelestialObject>(entityName: "CelestialObject")
    }

    @NSManaged public var angularSeparation: Double
    @NSManaged public var angularSize: Double
    @NSManaged public var declination: Double
    @NSManaged public var distance: Double
    @NSManaged public var epoch: Date?
    @NSManaged public var magnitude: Double
    @NSManaged public var positionAngle: Double
    @NSManaged public var properMotionDec: Double
    @NSManaged public var properMotionRA: Double
    @NSManaged public var rightAscension: Double
    @NSManaged public var type: String?
    @NSManaged public var area: UMArea?
    @NSManaged public var children: NSSet?
    @NSManaged public var designations: NSOrderedSet?
    @NSManaged public var identifiers: NSOrderedSet?
    @NSManaged public var names: NSOrderedSet?
    @NSManaged public var parents: NSSet?
    @NSManaged public var properties: NSOrderedSet?

}

// MARK: Generated accessors for children
extension UMCelestialObject {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: UMCelestialObject)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: UMCelestialObject)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for designations
extension UMCelestialObject {

    @objc(insertObject:inDesignationsAtIndex:)
    @NSManaged public func insertIntoDesignations(_ value: UMObjectDesignation, at idx: Int)

    @objc(removeObjectFromDesignationsAtIndex:)
    @NSManaged public func removeFromDesignations(at idx: Int)

    @objc(insertDesignations:atIndexes:)
    @NSManaged public func insertIntoDesignations(_ values: [UMObjectDesignation], at indexes: NSIndexSet)

    @objc(removeDesignationsAtIndexes:)
    @NSManaged public func removeFromDesignations(at indexes: NSIndexSet)

    @objc(replaceObjectInDesignationsAtIndex:withObject:)
    @NSManaged public func replaceDesignations(at idx: Int, with value: UMObjectDesignation)

    @objc(replaceDesignationsAtIndexes:withDesignations:)
    @NSManaged public func replaceDesignations(at indexes: NSIndexSet, with values: [UMObjectDesignation])

    @objc(addDesignationsObject:)
    @NSManaged public func addToDesignations(_ value: UMObjectDesignation)

    @objc(removeDesignationsObject:)
    @NSManaged public func removeFromDesignations(_ value: UMObjectDesignation)

    @objc(addDesignations:)
    @NSManaged public func addToDesignations(_ values: NSOrderedSet)

    @objc(removeDesignations:)
    @NSManaged public func removeFromDesignations(_ values: NSOrderedSet)

}

// MARK: Generated accessors for identifiers
extension UMCelestialObject {

    @objc(insertObject:inIdentifiersAtIndex:)
    @NSManaged public func insertIntoIdentifiers(_ value: UMIdentifier, at idx: Int)

    @objc(removeObjectFromIdentifiersAtIndex:)
    @NSManaged public func removeFromIdentifiers(at idx: Int)

    @objc(insertIdentifiers:atIndexes:)
    @NSManaged public func insertIntoIdentifiers(_ values: [UMIdentifier], at indexes: NSIndexSet)

    @objc(removeIdentifiersAtIndexes:)
    @NSManaged public func removeFromIdentifiers(at indexes: NSIndexSet)

    @objc(replaceObjectInIdentifiersAtIndex:withObject:)
    @NSManaged public func replaceIdentifiers(at idx: Int, with value: UMIdentifier)

    @objc(replaceIdentifiersAtIndexes:withIdentifiers:)
    @NSManaged public func replaceIdentifiers(at indexes: NSIndexSet, with values: [UMIdentifier])

    @objc(addIdentifiersObject:)
    @NSManaged public func addToIdentifiers(_ value: UMIdentifier)

    @objc(removeIdentifiersObject:)
    @NSManaged public func removeFromIdentifiers(_ value: UMIdentifier)

    @objc(addIdentifiers:)
    @NSManaged public func addToIdentifiers(_ values: NSOrderedSet)

    @objc(removeIdentifiers:)
    @NSManaged public func removeFromIdentifiers(_ values: NSOrderedSet)

}

// MARK: Generated accessors for names
extension UMCelestialObject {

    @objc(insertObject:inNamesAtIndex:)
    @NSManaged public func insertIntoNames(_ value: UMName, at idx: Int)

    @objc(removeObjectFromNamesAtIndex:)
    @NSManaged public func removeFromNames(at idx: Int)

    @objc(insertNames:atIndexes:)
    @NSManaged public func insertIntoNames(_ values: [UMName], at indexes: NSIndexSet)

    @objc(removeNamesAtIndexes:)
    @NSManaged public func removeFromNames(at indexes: NSIndexSet)

    @objc(replaceObjectInNamesAtIndex:withObject:)
    @NSManaged public func replaceNames(at idx: Int, with value: UMName)

    @objc(replaceNamesAtIndexes:withNames:)
    @NSManaged public func replaceNames(at indexes: NSIndexSet, with values: [UMName])

    @objc(addNamesObject:)
    @NSManaged public func addToNames(_ value: UMName)

    @objc(removeNamesObject:)
    @NSManaged public func removeFromNames(_ value: UMName)

    @objc(addNames:)
    @NSManaged public func addToNames(_ values: NSOrderedSet)

    @objc(removeNames:)
    @NSManaged public func removeFromNames(_ values: NSOrderedSet)

}

// MARK: Generated accessors for parents
extension UMCelestialObject {

    @objc(addParentsObject:)
    @NSManaged public func addToParents(_ value: UMCelestialObject)

    @objc(removeParentsObject:)
    @NSManaged public func removeFromParents(_ value: UMCelestialObject)

    @objc(addParents:)
    @NSManaged public func addToParents(_ values: NSSet)

    @objc(removeParents:)
    @NSManaged public func removeFromParents(_ values: NSSet)

}

// MARK: Generated accessors for properties
extension UMCelestialObject {

    @objc(insertObject:inPropertiesAtIndex:)
    @NSManaged public func insertIntoProperties(_ value: UMProperty, at idx: Int)

    @objc(removeObjectFromPropertiesAtIndex:)
    @NSManaged public func removeFromProperties(at idx: Int)

    @objc(insertProperties:atIndexes:)
    @NSManaged public func insertIntoProperties(_ values: [UMProperty], at indexes: NSIndexSet)

    @objc(removePropertiesAtIndexes:)
    @NSManaged public func removeFromProperties(at indexes: NSIndexSet)

    @objc(replaceObjectInPropertiesAtIndex:withObject:)
    @NSManaged public func replaceProperties(at idx: Int, with value: UMProperty)

    @objc(replacePropertiesAtIndexes:withProperties:)
    @NSManaged public func replaceProperties(at indexes: NSIndexSet, with values: [UMProperty])

    @objc(addPropertiesObject:)
    @NSManaged public func addToProperties(_ value: UMProperty)

    @objc(removePropertiesObject:)
    @NSManaged public func removeFromProperties(_ value: UMProperty)

    @objc(addProperties:)
    @NSManaged public func addToProperties(_ values: NSOrderedSet)

    @objc(removeProperties:)
    @NSManaged public func removeFromProperties(_ values: NSOrderedSet)

}
