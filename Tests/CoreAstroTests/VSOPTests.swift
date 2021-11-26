//
//  VSOPTests.swift
//  
//
//  Created by Don Willems on 23/11/2021.
//

import Foundation
import XCTest
import CoreMeasure
@testable import CoreAstro

final class VSOPTests: XCTestCase {
    
    func testVSOPFile() throws {
        let sun = SolarSystem.sun
        let venus = Planet.venus
        print("\n** SUN **")
        try self.printPositions(object: sun)
        print("\n** VENUS **")
        try self.printPositions(object: venus)
    }
    
    func printPositions(object: CelestialObject) throws {
        let coordinates = object.equatorialCoordinates(on: Date())
        let geocentriccs = CoordinateSystem.equatorial(for: .J2000, from: .geocentric)
        let geocentric = try coordinates.convert(to: geocentriccs, positionType: .meanPosition)
        let heliocentriccs = CoordinateSystem.equatorial(for: .J2000, from: .heliocentric)
        let heliocentric = try coordinates.convert(to: heliocentriccs, positionType: .meanPosition)
        print("   barycentric: \(coordinates)")
        print("    geocentric: \(geocentric)")
        print("  heliocentric: \(heliocentric)")
        //print("   \(coordinates.rectangularCoordinates)\n-> \(converted.rectangularCoordinates)")
    }
}
