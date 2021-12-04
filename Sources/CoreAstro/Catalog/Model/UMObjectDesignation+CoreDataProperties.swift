//
//  UMObjectDesignation+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 01/12/2021.
//
//

import Foundation
import CoreData


extension UMObjectDesignation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMObjectDesignation> {
        return NSFetchRequest<UMObjectDesignation>(entityName: "ObjectDesignation")
    }

    @NSManaged public var bayer: String?
    @NSManaged public var bayerComponent: Int16
    @NSManaged public var constellationAbbreviation: String?
    @NSManaged public var flamsteed: Int16
    @NSManaged public var variableStar: String?
    @NSManaged public var object: UMCelestialObject?

}
