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
    
    func testVSOPFile() {
        let earth = Planet.earth
        let coordinates = earth.equatorialCoordinates(on: Date())
    }
}
