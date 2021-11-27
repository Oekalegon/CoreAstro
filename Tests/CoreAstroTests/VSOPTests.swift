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
        print("\n** SUN **")
        try self.printPositions(object: sun)
        for planet in SolarSystem.planets {
            print("\n** \(planet.name!.uppercased()) **")
            try self.printPositions(object: planet)
        }
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
    
    func testHeliocentric() throws {
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, timeZone: TimeZone.init(abbreviation: "GMT"), era: nil, year: 2021, month: 11, day: 27, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let date = calendar.date(from: components)!
        print("Date: \(date)")
        let mercuryCoord = Planet.mercury.eclipticalCoordinates(on: date, from: .heliocentric)
        XCTAssertEqual(try mercuryCoord.longitude.convert(to: .degree).scalarValue, 241.106666666, accuracy: 1/3600)
        XCTAssertEqual(try mercuryCoord.latitude.convert(to: .degree).scalarValue, -1.52545, accuracy: 1/3600)
        XCTAssertEqual(try mercuryCoord.distance!.convert(to: .astronomicalUnit).scalarValue, 0.4617138, accuracy: 0.0001)
        
        let marsCoord = Planet.mars.eclipticalCoordinates(on: date, from: .heliocentric)
        XCTAssertEqual(try marsCoord.longitude.convert(to: .degree).scalarValue, 218.52020, accuracy: 1/3600)
        XCTAssertEqual(try marsCoord.latitude.convert(to: .degree).scalarValue, 0.35949, accuracy: 1/3600)
        XCTAssertEqual(try marsCoord.distance!.convert(to: .astronomicalUnit).scalarValue, 1.5796263, accuracy: 0.0001)
        
        let jupiterCoord = Planet.jupiter.eclipticalCoordinates(on: date, from: .heliocentric)
        XCTAssertEqual(try jupiterCoord.longitude.convert(to: .degree).scalarValue, 336.08652, accuracy: 1/3600)
        XCTAssertEqual(try jupiterCoord.latitude.convert(to: .degree).scalarValue, -1.07225, accuracy: 1/3600)
        XCTAssertEqual(try jupiterCoord.distance!.convert(to: .astronomicalUnit).scalarValue, 5.0003863, accuracy: 0.0001)
        
        let uranusCoord = Planet.uranus.eclipticalCoordinates(on: date, from: .heliocentric)
        XCTAssertEqual(try uranusCoord.longitude.convert(to: .degree).scalarValue, 43.02941, accuracy: 1/3600)
        XCTAssertEqual(try uranusCoord.latitude.convert(to: .degree).scalarValue, -0.39893, accuracy: 1/3600)
        XCTAssertEqual(try uranusCoord.distance!.convert(to: .astronomicalUnit).scalarValue, 19.7276142, accuracy: 0.0001)
        
        let neptuneCoord = Planet.neptune.eclipticalCoordinates(on: date, from: .heliocentric)
        XCTAssertEqual(try neptuneCoord.longitude.convert(to: .degree).scalarValue, 352.23445, accuracy: 1/3600)
        XCTAssertEqual(try neptuneCoord.latitude.convert(to: .degree).scalarValue, -1.14178, accuracy: 1/3600)
        XCTAssertEqual(try neptuneCoord.distance!.convert(to: .astronomicalUnit).scalarValue, 29.9209465, accuracy: 0.0001)
    }
}
