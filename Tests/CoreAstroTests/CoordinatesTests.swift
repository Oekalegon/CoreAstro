//
//  CoordinatesTests.swift
//  
//
//  Created by Don Willems on 19/11/2021.
//

import XCTest
import CoreMeasure
@testable import CoreAstro

final class CoordinatesTests: XCTestCase {
    
    func testAngularSeparation() throws {
        let α_arcturus = try Longitude(213.9154, unit: .degree)
        let δ_arcturus = try Latitude(19.1825, unit: .degree)
        let α_spica = try Longitude(201.2983, unit: .degree)
        let δ_spica = try Latitude(-11.1614, unit: .degree)
        let eq_arcturus = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α_arcturus, latitude: δ_arcturus), system: .equatorialJ2000, positionType: .meanPosition)
        let eq_spica = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α_spica, latitude: δ_spica), system: .equatorialJ2000, positionType: .meanPosition)
        let d = try eq_arcturus.angularSeparation(to: eq_spica)
        let d_deg = try d.convert(to: .degree)
        XCTAssertEqual(d_deg.scalarValue, 32.7930, accuracy: 0.0001)
    }
    
    func testPositionAngle() throws {
        // TODO: Test in other coordinate systems (esp: Azimuthal)
        let α = try Longitude(213.9154, unit: .degree)
        let δ = try Latitude(19.1825, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let αN = try Longitude(213.9154, unit: .degree)
        let δN = try Latitude(19.2825, unit: .degree)
        let eqN = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: αN, latitude: δN), system: .equatorialJ2000, positionType: .meanPosition)
        let PN = try Coordinates.relativePositionAngle(from: eq, to: eqN)
        let PN_deg = try PN.convert(to: .degree)
        XCTAssertEqual(PN_deg.scalarValue, 0.0, accuracy: 0.0001)
        let PNr = try Coordinates.relativePositionAngle(from: eqN, to: eq)
        let PNr_deg = try PNr.convert(to: .degree)
        XCTAssertEqual(PNr_deg.scalarValue, 180.0, accuracy: 0.0001)
        let αE = try Longitude(213.9155, unit: .degree)
        let δE = try Latitude(19.1825, unit: .degree)
        let eqE = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: αE, latitude: δE), system: .equatorialJ2000, positionType: .meanPosition)
        let PE = try Coordinates.relativePositionAngle(from: eq, to: eqE)
        let PE_deg = try PE.convert(to: .degree)
        XCTAssertEqual(PE_deg.scalarValue, 90.0, accuracy: 0.0001)
        let PEr = try Coordinates.relativePositionAngle(from: eqE, to: eq)
        let PEr_deg = try PEr.convert(to: .degree)
        XCTAssertEqual(PEr_deg.scalarValue, 270, accuracy: 0.0001)
    }
}
