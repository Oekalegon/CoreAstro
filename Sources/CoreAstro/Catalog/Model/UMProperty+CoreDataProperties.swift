//
//  UMProperty+CoreDataProperties.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData

extension UMProperty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UMProperty> {
        return NSFetchRequest<UMProperty>(entityName: "UMProperty")
    }

    @NSManaged public var booleanValue: Bool
    @NSManaged public var comment: String?
    @NSManaged public var dateValue: Date?
    @NSManaged public var numericalValue: Double
    @NSManaged public var stringValue: String?
    @NSManaged public var type: String?
    @NSManaged public var unit: String?
    @NSManaged public var object: UMCelestialObject?

}
