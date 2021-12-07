//
//  UMCelestialObject+CoreDataClass.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData
import CoreMeasure


public class UMCelestialObject: NSManagedObject {
    
    public var catalogObject: CatalogObject? {
        get {
            var catalogObject: CatalogObject? = nil
            if self.isa(type: .star) {
                catalogObject = try? CatalogStar(names: self.objectNames,
                                                 bayer: self.bayerDesignation,
                                                 flamsteed: self.flamsteedDesignation,
                                                 variableStarDesignation: self.variableStarDesignation,
                                                 identifiers: self.objectIdentifiers,
                                                 types: self.objectTypes,
                                                 coordinates: self.coordinates,
                                                 magnitude: self.visualMagnitude,
                                                 constellation: self.constellation)
            }
            return catalogObject
        }
    }
    
    public var objectNames: [StringLiteral] {
        get {
            var onames = [StringLiteral]()
            let umnames = self.names?.array
            if umnames != nil {
                for umname in umnames! {
                    let umnameO = umname as! UMName
                    if umnameO.language == nil || umnameO.language!.count < 4 {
                        let name = StringLiteral(umnameO.name!, language: umnameO.language)
                        onames.append(name)
                    }
                }
            }
            return onames
        }
    }
    
    public var bayerDesignation: BayerDesignation? {
        get {
            let objectDesignatons = self.designations?.array
            if objectDesignatons != nil {
                for od in objectDesignatons! {
                    let bayer = (od as! UMObjectDesignation).bayerDesignation
                    if bayer != nil {
                        return bayer
                    }
                }
            }
            return nil
        }
    }
    
    public var flamsteedDesignation: FlamsteedDesignation? {
        get {
            let objectDesignatons = self.designations?.array
            if objectDesignatons != nil {
                for od in objectDesignatons! {
                    let flamsteed = (od as! UMObjectDesignation).flamsteedDesignation
                    if flamsteed != nil {
                        return flamsteed
                    }
                }
            }
            return nil
        }
    }
    
    public var variableStarDesignation: VariableStarDesignation? {
        get {
            let objectDesignatons = self.designations?.array
            if objectDesignatons != nil {
                for od in objectDesignatons! {
                    let vs = (od as! UMObjectDesignation).variableStarDesignation
                    if vs != nil {
                        return vs
                    }
                }
            }
            return nil
        }
    }
    
    public var objectIdentifiers: [ObjectIdentifier] {
        get {
            var oids = [ObjectIdentifier]()
            let umids = self.identifiers?.array
            if umids != nil {
                for umid in umids! {
                    let umidO = umid as! UMIdentifier
                    let id = ObjectIdentifier(identifier: umidO.identifier!, catalogIdentifier: umidO.catalog!.abbreviation!)
                    oids.append(id)
                }
            }
            return oids
        }
    }
    
    public var objectTypes: [CelestialObjectType] {
        get {
            var otypes = [CelestialObjectType]()
            for umtype in self.types! {
                if (umtype as! UMType).type != nil {
                    otypes.append((umtype as! UMType).type!)
                }
            }
            return otypes
        }
    }
    
    public var coordinates: Coordinates {
        get {
            let eqJ2000 = CoordinateSystem.equatorial(for: .J2000, from: .heliocentric)
            let ra = try! RightAscension(self.rightAscension)
            let dec = try! Declination(self.declination)
            let spherical = SphericalCoordinates(longitude: ra, latitude: dec)
            return Coordinates(sphericalCoordinates: spherical, system: eqJ2000, positionType: .meanPosition)
        }
    }
    
    public var constellation: Constellation? {
        get {
            let vsd = self.variableStarDesignation
            if vsd != nil {
                return vsd!.constellation
            }
            let flamsteed = self.flamsteedDesignation
            if flamsteed != nil {
                return flamsteed!.constellation
            }
            let bayer = self.bayerDesignation
            if bayer != nil {
                return bayer!.constellation
            }
            return nil
        }
    }
    
    public var visualMagnitude: Magnitude {
        get {
            return try! Magnitude(symbol: "mV", self.magnitude)
        }
    }
    
    

    public func isa(type: CelestialObjectType) -> Bool {
        if self.types == nil {
            return false
        }
        for umtype in self.types! {
            if (umtype as! UMType).type == type {
                return true
            }
        }
        return false
    }
}
