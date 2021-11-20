//
//  Star.swift
//  
//
//  Created by Don Willems on 20/11/2021.
//

import Foundation

public class Star: CatalogObject {
    
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
    
    private let coordinates: Coordinates
    
    public init(names: [StringLiteral], identifiers: [ObjectIdentifier], coordinates: Coordinates) throws {
        self.names = names
        self.identifiers = identifiers
        self.coordinates = try coordinates.convert(to: .ICRS, positionType: .meanPosition)
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
    
    public func eclipticalCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        let icrs = self.equatorialCoordinates(on: date)
        return try! icrs.convert(to: .ecliptical(at: date, from: location), positionType: .meanPosition)
    }
    
    public func horizontalCoordinates(on date: Date, from location: GeographicalLocation) -> Coordinates {
        let icrs = self.equatorialCoordinates(on: date)
        return try! icrs.convert(to: .horizontal(at: date, for: location), positionType: .apparentPosition)
    }

}
