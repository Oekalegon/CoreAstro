//
//  SiderealTimeTests.swift
//  
//
//  Created by Don Willems on 07/08/2021.
//

import XCTest
import CoreMeasure
@testable import CoreAstro

final class SiderealTimeTests: XCTestCase {
    
    func testMeanSiderealTimeAtGreenwich0UT() throws {
        let JD = JulianDay(2446895.5)
        let θ = try? SiderealTime(on: Date(julianDay: JD), at: GeographicalLocation(name: "Greenwich", longitude: Longitude(0.0, unit: .degree), latitude: Latitude(50.0, unit: .degree), elevation: nil))
        XCTAssertNotNil(θ)
        let expected : Double = 13.0*15.0 + 10*0.25 + 46.3668*0.25/60.0
        XCTAssertEqual(θ!.scalarValue, expected, accuracy: 0.000003)
        XCTAssertEqual(θ!.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ!.positionType, .meanPosition)
    }
    
    func testApparentSiderealTimeAtGreenwich0UT() throws {
        let JD = JulianDay(2446895.5)
        let θ = try? SiderealTime(on: Date(julianDay: JD), at: GeographicalLocation(name: "Greenwich", longitude: Longitude(0.0, unit: .degree), latitude: Latitude(50.0, unit: .degree), elevation: nil), positionType: .apparentPosition)
        XCTAssertNotNil(θ)
        let expected : Double = 13.0*15.0 + 10*0.25 + 46.1351*0.25/60.0
        XCTAssertEqual(θ!.scalarValue, expected, accuracy: 0.000003)
        XCTAssertEqual(θ!.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ!.positionType, .apparentPosition)
    }
    
    func testMeanSiderealTimeAtGreenwich() throws {
        let JD = JulianDay(2446896.30625)
        let θ = try? SiderealTime(on: Date(julianDay: JD), at: GeographicalLocation(name: "Greenwich", longitude: Longitude(0.0, unit: .degree), latitude: Latitude(50.0, unit: .degree), elevation: nil))
        XCTAssertNotNil(θ)
        XCTAssertEqual(θ!.scalarValue, 128.7378734, accuracy: 0.000003)
        XCTAssertEqual(θ!.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ!.positionType, .meanPosition)
    }
    
    func testMeanSiderealTime() throws {
        let JD = JulianDay(2446896.30625)
        let θ = try? SiderealTime(on: Date(julianDay: JD), at: GeographicalLocation(name: "US Naval Observatory", longitude: Longitude(77.065555555556, unit: .degree), latitude: Latitude(38.9213888888889, unit: .degree), elevation: nil))
        XCTAssertNotNil(θ)
        XCTAssertEqual(θ!.scalarValue, 128.7378734-77.065555555556, accuracy: 0.000003)
        XCTAssertEqual(θ!.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ!.positionType, .meanPosition)
    }
    
    func testMeanSiderealTimeFromLocation() throws {
        let location = try! GeographicalLocation(name: "US Naval Observatory",
                                                 longitude: Longitude(77.065555555556, unit: .degree),
                                                 latitude: Latitude(38.9213888888889, unit: .degree),
                                                 elevation: nil)
        let JD = JulianDay(2446896.30625)
        let θ = location.siderealTime(on: Date(julianDay: JD), positionType: .meanPosition)
        XCTAssertNotNil(θ)
        XCTAssertEqual(θ.scalarValue, 128.7378734-77.065555555556, accuracy: 0.000003)
        XCTAssertEqual(θ.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ.positionType, .meanPosition)
    }
    
    func testApparentSiderealTime() throws {
        let JD = JulianDay(2446896.30625)
        let θ = try? SiderealTime(on: Date(julianDay: JD), at: GeographicalLocation(name: "US Naval Observatory", longitude: Longitude(77.065555555556, unit: .degree), latitude: Latitude(38.9213888888889, unit: .degree), elevation: nil), positionType: .apparentPosition)
        XCTAssertNotNil(θ)
        let expected : Double = (8.0-5.0)*15.0 + (34.0-8.0)*0.25 + (56.853-15.7)*0.25/60.0
        XCTAssertEqual(θ!.scalarValue, expected, accuracy: 0.000003)
        XCTAssertEqual(θ!.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ!.positionType, .apparentPosition)
    }
    
    func testApparentSiderealTimeFromLocation() throws {
        let location = try! GeographicalLocation(name: "US Naval Observatory",
                                                 longitude: Longitude(77.065555555556, unit: .degree),
                                                 latitude: Latitude(38.9213888888889, unit: .degree),
                                                 elevation: nil)
        let JD = JulianDay(2446896.30625)
        let θ = location.siderealTime(on: Date(julianDay: JD), positionType: .apparentPosition)
        let expected : Double = (8.0-5.0)*15.0 + (34.0-8.0)*0.25 + (56.853-15.7)*0.25/60.0
        XCTAssertNotNil(θ)

        XCTAssertEqual(θ.scalarValue, expected, accuracy: 0.000003)
        XCTAssertEqual(θ.unit, CoreMeasure.Unit.degree)
        XCTAssertEqual(θ.positionType, .apparentPosition)
    }
}
