//
//  CelestialArea.swift
//  
//
//  Created by Don Willems on 21/05/2021.
//

import Foundation
import SwiftAA

public protocol CelestialArea {
    
    var equinox : Equinox { get }
    var containedInEquirectangularCelestialArea : EquirectangularCelestialArea { get }
    func contains(coordinates: EquatorialCoordinates) -> Bool
    func intersects(with: CelestialArea) -> Bool
    func precessedAreaCoordinates(to: Equinox) -> CelestialArea
}

public struct EquirectangularCelestialArea : CelestialArea {
    
    public let equinox : Equinox
    public let northEastCoordinates : EquatorialCoordinates
    public let southWestCoordinates : EquatorialCoordinates
    
    public var southEastCoordinates: EquatorialCoordinates {
        get {
            return EquatorialCoordinates(rightAscension: northEastCoordinates.rightAscension, declination: southWestCoordinates.declination, epoch: southWestCoordinates.epoch, equinox: southWestCoordinates.equinox)
        }
    }
    
    public var northWestCoordinates: EquatorialCoordinates {
        get {
            return EquatorialCoordinates(rightAscension: southWestCoordinates.rightAscension, declination: northEastCoordinates.declination, epoch: southWestCoordinates.epoch, equinox: southWestCoordinates.equinox)
        }
    }
    
    public init(southWest: EquatorialCoordinates, northEast: EquatorialCoordinates, equinox: Equinox = .standardJ2000) {
        self.equinox = equinox
        self.southWestCoordinates = southWest.precessedCoordinates(to: equinox)
        self.northEastCoordinates = northEast.precessedCoordinates(to: equinox)
    }
    
    private var crossesZeroRA : Bool {
        get {
            return self.southWestCoordinates.rightAscension > self.northEastCoordinates.rightAscension
        }
    }
    
    public var containedInEquirectangularCelestialArea : EquirectangularCelestialArea {
        get {
            return self
        }
    }
    
    public func contains(coordinates: EquatorialCoordinates) -> Bool {
        let prescoord = coordinates.precessedCoordinates(to: self.equinox)
        if !(prescoord.declination <= northEastCoordinates.declination && prescoord.declination >= southWestCoordinates.declination) {
            return false
        }
        if prescoord.rightAscension <= northEastCoordinates.rightAscension && prescoord.rightAscension >= southWestCoordinates.rightAscension {
            return true
        }
        if self.crossesZeroRA {
            if prescoord.rightAscension >= northEastCoordinates.rightAscension || prescoord.rightAscension <= southWestCoordinates.rightAscension {
                return true
            }
        }
        return false
    }
    
    public func intersects(with area: CelestialArea) -> Bool {
        let precarea = area.precessedAreaCoordinates(to: self.equinox)
        let rectarea = precarea.containedInEquirectangularCelestialArea
        if !(rectarea.southWestCoordinates.declination < self.northEastCoordinates.declination && rectarea.northEastCoordinates.declination > self.southWestCoordinates.declination) {
            return false
        }
        var selfNEra = self.northEastCoordinates.rightAscension
        var selfSWra = self.southWestCoordinates.rightAscension
        var areaNEra = rectarea.northEastCoordinates.rightAscension
        var areaSWra = rectarea.southWestCoordinates.rightAscension
        
        if areaSWra < selfNEra && areaNEra > selfSWra {
            return true
        }
        
        if self.crossesZeroRA || rectarea.crossesZeroRA {
            if self.crossesZeroRA {
                selfSWra = selfSWra - 24.0
            }
            if rectarea.crossesZeroRA {
                areaSWra = areaSWra - 24.0
            }
            if areaSWra > 12.0 {
                areaSWra = areaSWra - 24.0
            }
            if selfSWra > 12.0 || selfNEra > 12.0 {
                selfSWra = selfSWra - 24.0
                selfNEra = selfNEra - 24.0
            }
            if areaSWra > 12.0 || areaNEra > 12.0 {
                areaSWra = areaSWra - 24.0
                areaNEra = areaNEra - 24.0
            }
            
            if areaSWra < selfNEra && areaNEra > selfSWra {
                return true
            }
        }
        return false
    }
    
    public func precessedAreaCoordinates(to newEquinox: Equinox) -> CelestialArea {
        var correctionForCrossing = Hour(0.0)
        if self.crossesZeroRA {
            correctionForCrossing = Hour(-24.0)
        }
        let nw = EquatorialCoordinates(rightAscension: southWestCoordinates.rightAscension, declination: northEastCoordinates.declination,equinox: equinox).precessedCoordinates(to: newEquinox)
        let ne = EquatorialCoordinates(rightAscension: northEastCoordinates.rightAscension, declination: northEastCoordinates.declination,equinox: equinox).precessedCoordinates(to: newEquinox)
        let sw = EquatorialCoordinates(rightAscension: southWestCoordinates.rightAscension, declination: southWestCoordinates.declination,equinox: equinox).precessedCoordinates(to: newEquinox)
        let se = EquatorialCoordinates(rightAscension: northEastCoordinates.rightAscension, declination: southWestCoordinates.declination,equinox: equinox).precessedCoordinates(to: newEquinox)
        let ras = [nw.rightAscension + correctionForCrossing, ne.rightAscension, sw.rightAscension + correctionForCrossing, se.rightAscension]
        let decs = [nw.declination, ne.declination, sw.declination, se.declination]
        let maxras = ras.max()!
        let minras = ras.min()!
        let maxdec = decs.max()!
        let mindec = decs.min()!
        let newMax = EquatorialCoordinates(rightAscension: maxras, declination: maxdec, epoch: northEastCoordinates.epoch, equinox: newEquinox)
        let newMin = EquatorialCoordinates(rightAscension: minras, declination: mindec, epoch: northEastCoordinates.epoch, equinox: newEquinox)
        let newArea = EquirectangularCelestialArea(southWest: newMin, northEast: newMax, equinox: newEquinox)
        return newArea
    }
}
