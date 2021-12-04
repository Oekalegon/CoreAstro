//
//  Star.swift
//  
//
//  Created by Don Willems on 20/11/2021.
//

import Foundation
import CoreMeasure

public protocol Star : CelestialObject {
    
}

public class CatalogStar: Star, CatalogObject, CustomStringConvertible {
    
    public var identifier: ObjectIdentifier {
        get {
            if identifiers.count < 1 {
                return ObjectIdentifier(identifier: "NO IDENTIFIER SET", catalogIdentifier: "[ERROR]")
            }
            return identifiers[0]
        }
    }
    
    public var identifiers: [ObjectIdentifier]
    
    public var name: String? {
        get {
            if names.count > 0 {
                return names[0].string
            }
            return nil
        }
    }
    
    public let names: [StringLiteral]
    
    public let types: [CelestialObjectType] 
    
    public func isOfType(_ type: CelestialObjectType) -> Bool {
        for objectType in types {
            if objectType.rawValue.contains(type.rawValue) {
                return true
            }
        }
        return false
    }
    
    public let bayerDesignation : BayerDesignation?
    public let flamsteedDesignation : FlamsteedDesignation?
    public let variableStarDesignation: VariableStarDesignation?
    
    private let coordinates: Coordinates
    private let constellation: Constellation?
    
    public init(names: [StringLiteral],
                bayer: BayerDesignation? = nil,
                flamsteed: FlamsteedDesignation? = nil,
                variableStarDesignation: VariableStarDesignation? = nil,
                identifiers: [ObjectIdentifier],
                types: [CelestialObjectType],
                coordinates: Coordinates,
                constellation: Constellation? = nil) throws {
        var tempNames = [StringLiteral]()
        tempNames.append(contentsOf: names)
        if bayer != nil {
            tempNames.append(StringLiteral(bayer!.designation, language: nil))
        }
        if flamsteed != nil {
            tempNames.append(StringLiteral(flamsteed!.designation, language: nil))
        }
        if variableStarDesignation != nil {
            tempNames.append(StringLiteral(variableStarDesignation!.designation, language: nil))
        }
        self.names = tempNames
        self.identifiers = identifiers
        self.coordinates = try coordinates.convert(to: .ICRS, positionType: .meanPosition)
        self.constellation = constellation
        self.types = types
        self.bayerDesignation = bayer
        self.flamsteedDesignation = flamsteed
        self.variableStarDesignation = variableStarDesignation
    }
    
    public func names(language: String?) -> [String] {
        var selectedNames = [String]()
        for name in names {
            if name.language == language {
                selectedNames.append(name.string)
            }
        }
        return selectedNames
    }
    
    public func equatorialCoordinates(on date: Date) -> Coordinates {
        // TODO: Correct for proper motion
        return coordinates
    }
    
    public func equatorialCoordinates(on date: Date, equinox: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        let icrs = self.equatorialCoordinates(on: date)
        let system = CoordinateSystem.equatorial(for: equinox, from: location)
        // TODO: Determine the position type based on location
        return try! icrs.convert(to: system, positionType: .meanPosition)
    }
    
    public func galacticCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        let icrs = self.equatorialCoordinates(on: date)
        // TODO: Determine the position type based on location
        return try! icrs.convert(to: .galactic, positionType: .meanPosition)
    }
    
    public func eclipticalCoordinates(on date: Date, eclipticAt ecliptic: Date? = nil, for equinox: Date? = nil, from location: CoordinateSystemOrigin) -> Coordinates {
        let icrs = self.equatorialCoordinates(on: date)
        var equinoxDate = date
        if equinox != nil {
            equinoxDate = equinox!
        }
        var eclipticDate = date
        if ecliptic != nil {
            eclipticDate = ecliptic!
        }
        return try! icrs.convert(to: .ecliptical(eclipticAt: eclipticDate, for: equinoxDate, from: location), positionType: .meanPosition)
    }
    
    public func horizontalCoordinates(on date: Date, from location: GeographicalLocation) -> Coordinates {
        let icrs = self.equatorialCoordinates(on: date)
        return try! icrs.convert(to: .horizontal(at: date, for: location), positionType: .apparentPosition)
    }
    
    public func constellation(on date: Date) -> Constellation {
        if self.constellation == nil {
            return Constellations.constellation(containing: coordinates)
        }
        return self.constellation!
    }
    
    public func elongation(on date: Date, from origin: CoordinateSystemOrigin) -> Angle {
        let sun = SolarSystem.sun.eclipticalCoordinates(on: date, from: origin)
        let coord = self.eclipticalCoordinates(on: date, from: origin)
        let separation = try! Coordinates.angularSeparation(between: coord, and: sun)
        return separation
    }
    
    public var description: String {
        get {
            var ident = self.name
            if ident == nil {
                ident = "[\(self.identifier.description)]"
            }
            let date = Date()
            return "\(ident!)   \(self.equatorialCoordinates(on:date)) in \(self.constellation(on:date).name)"
        }
    }
}
