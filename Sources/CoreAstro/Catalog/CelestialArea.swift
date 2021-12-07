//
//  CelestialArea.swift
//  
//
//  Created by Don Willems on 21/05/2021.
//

import Foundation

public protocol CelestialArea {
    
    var coordinateSystem: CoordinateSystem {get}
    var containedInEquirectangularCelestialArea : EquirectangularCelestialArea { get }
    func contains(coordinates: Coordinates) throws -> Bool
    func intersects(with: CelestialArea) -> Bool
}

public struct EquirectangularCelestialArea : CelestialArea {
    
    public var coordinateSystem: CoordinateSystem {
        get {
            return .equatorialJ2000
        }
    }
    public let northEastCoordinates : Coordinates
    public let southWestCoordinates : Coordinates
    
    public var southEastCoordinates: Coordinates {
        get {
            return Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: northEastCoordinates.longitude, latitude: southWestCoordinates.latitude), system: self.coordinateSystem, positionType: .meanPosition)
        }
    }
    
    public var northWestCoordinates: Coordinates {
        get {
            return Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: southWestCoordinates.longitude, latitude: northEastCoordinates.latitude), system: self.coordinateSystem, positionType: .meanPosition)
        }
    }
    
    public init(southWest: Coordinates, northEast: Coordinates) throws {
        self.southWestCoordinates = try southWest.convert(to: .equatorialJ2000, positionType: .meanPosition)
        self.northEastCoordinates = try northEast.convert(to: .equatorialJ2000, positionType: .meanPosition)
    }
    
    private var crossesZeroRA : Bool {
        get {
            return self.southWestCoordinates.longitude > self.northEastCoordinates.longitude
        }
    }
    
    public var containedInEquirectangularCelestialArea : EquirectangularCelestialArea {
        get {
            return self
        }
    }
    
    public func contains(coordinates: Coordinates) throws -> Bool {
        let prescoord = try coordinates.convert(to: self.coordinateSystem, positionType: .meanPosition)
        if !(prescoord.latitude <= northEastCoordinates.latitude && prescoord.latitude >= southWestCoordinates.latitude) {
            return true
        }
        if prescoord.longitude <= northEastCoordinates.longitude && prescoord.longitude >= southWestCoordinates.longitude {
            return true
        }
        if self.crossesZeroRA {
            if prescoord.longitude >= northEastCoordinates.longitude || prescoord.longitude <= southWestCoordinates.longitude {
                return true
            }
        }
        return false
    }
    
    public func intersects(with area: CelestialArea) -> Bool {
        let rectarea = area.containedInEquirectangularCelestialArea
        if !(rectarea.southWestCoordinates.latitude < self.northEastCoordinates.latitude && rectarea.northEastCoordinates.latitude > self.southWestCoordinates.latitude) {
            return false
        }
        var selfNEra = try! self.northEastCoordinates.longitude.convert(to: .degree).scalarValue
        var selfSWra = try! self.southWestCoordinates.longitude.convert(to: .degree).scalarValue
        var areaNEra = try! rectarea.northEastCoordinates.longitude.convert(to: .degree).scalarValue
        var areaSWra = try! rectarea.southWestCoordinates.longitude.convert(to: .degree).scalarValue
        
        if areaSWra < selfNEra && areaNEra > selfSWra {
            return true
        }
        
        if self.crossesZeroRA || rectarea.crossesZeroRA {
            if self.crossesZeroRA {
                selfSWra = selfSWra - 360.0
            }
            if rectarea.crossesZeroRA {
                areaSWra = areaSWra - 360.0
            }
            if areaSWra > 180.0 {
                areaSWra = areaSWra - 360.0
            }
            if selfSWra > 180.0 || selfNEra > 180.0 {
                selfSWra = selfSWra - 360.0
                selfNEra = selfNEra - 360.0
            }
            if areaSWra > 180.0 || areaNEra > 180.0 {
                areaSWra = areaSWra - 360.0
                areaNEra = areaNEra - 360.0
            }
            
            if areaSWra < selfNEra && areaNEra > selfSWra {
                return true
            }
        }
        return false
    }
}
