//
//  NutationTests.swift
//  
//
//  Created by Don Willems on 08/08/2021.
//

import XCTest
import CoreMeasure
@testable import CoreAstro

final class NutationTests: XCTestCase {
    
    func testNutation() throws {
        let JD = JulianDay(2446895.5)
        let date = Date(julianDay: JD)
        let nutation = nutation(on: date)
        XCTAssertEqual(nutation.Δψ.scalarValue, -3.788, accuracy: 0.001)
        XCTAssertEqual(nutation.Δψ.unit, .arcsecond)
        XCTAssertEqual(nutation.Δε.scalarValue, 9.443, accuracy: 0.001)
        XCTAssertEqual(nutation.Δε.unit, .arcsecond)
    }
    
    func testObliquity() throws {
        let JD = JulianDay(2446895.5)
        let date = Date(julianDay: JD)
        let ε0 = try meanObliquityOfTheEcliptic(on: date)
        let ε = try trueObliquityOfTheEcliptic(on: date)
        let expected0 : Double = 23 + 26/60.0 + 27.407/3600.0
        let expected : Double = 23 + 26/60.0 + 36.850/3600.0
        XCTAssertEqual(ε0.scalarValue, expected0, accuracy: 0.001/3600)
        XCTAssertEqual(ε0.unit, .degree)
        XCTAssertEqual(ε.scalarValue, expected, accuracy: 0.001/3600)
        XCTAssertEqual(ε.unit, .degree)
    }
}
