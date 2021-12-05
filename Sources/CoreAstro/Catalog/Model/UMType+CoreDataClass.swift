//
//  UMType+CoreDataClass.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData


public class UMType: NSManagedObject {
    
    public var type: CelestialObjectType? {
        get {
            for otype in CelestialObjectType.allCases {
                if self.name == otype.rawValue {
                    return otype
                }
            }
            return nil
        }
    }
}
