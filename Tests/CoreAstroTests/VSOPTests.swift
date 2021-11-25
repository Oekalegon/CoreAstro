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
        let uranus = Planet.uranus
        let coordinates = uranus.equatorialCoordinates(on: Date())
        let targetcs = CoordinateSystem.equatorial(for: .J2000, from: .geocentric)
        let converted = try coordinates.convert(to: targetcs, positionType: .meanPosition)
        print("   \(coordinates)\n-> \(converted)")
        //print("   \(coordinates.rectangularCoordinates)\n-> \(converted.rectangularCoordinates)")
    }
}
