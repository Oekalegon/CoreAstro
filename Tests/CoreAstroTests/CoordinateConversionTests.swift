//
//  CoordinateConversionTests.swift
//  
//
//  Created by Don Willems on 16/08/2021.
//
import XCTest
import CoreMeasure
@testable import CoreAstro

final class CoordinateConversionTests: XCTestCase {
    
    func testEquatorialToEclipticalZero() throws {
        let α = try Longitude(0, unit: .degree)
        let δ = try Latitude(0, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let ecl = try eq.convert(to: .ecliptical(at: .J2000), positionType: .meanPosition)
        let λ = try Longitude(measure: try ecl.sphericalCoordinates.longitude.convert(to: .degree))
        let β = try ecl.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(λ, try! Longitude(0, unit: .degree))
        XCTAssertEqual(β.scalarValue, 0.0, accuracy: 0.000002)
    }
    
    func testEquatorialToEcliptical180() throws {
        let α = try Longitude(180, unit: .degree)
        let δ = try Latitude(0, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let ecl = try eq.convert(to: .ecliptical(at: .J2000), positionType: .meanPosition)
        let λ = try ecl.sphericalCoordinates.longitude.convert(to: .degree)
        let β = try ecl.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(λ.scalarValue, 180.0, accuracy: 0.000002)
        XCTAssertEqual(β.scalarValue, 0.0, accuracy: 0.000002)
    }
    
    func testEquatorialToEclipticalNP() throws {
        let α = try Longitude(0, unit: .degree)
        let δ = try Latitude(90, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let ecl = try eq.convert(to: .ecliptical(at: .J2000), positionType: .meanPosition)
        let λ = try ecl.sphericalCoordinates.longitude.convert(to: .degree)
        let β = try ecl.sphericalCoordinates.latitude.convert(to: .degree)
        let ε = try meanObliquityOfTheEcliptic(on: .J2000).convert(to: .degree)
        XCTAssertEqual(λ.scalarValue, 90.0, accuracy: 0.000002)
        XCTAssertEqual(β.scalarValue, 90.0 - ε.scalarValue, accuracy: 0.000002)
    }
    
    func testEquatorialToEcliptical() throws {
        let α_pollux = try Longitude(116.328942, unit: .degree)
        let δ_pollux = try Latitude(28.026183, unit: .degree)
        let eq_pollux = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α_pollux, latitude: δ_pollux), system: .equatorialJ2000, positionType: .meanPosition)
        let ecl_pollux = try eq_pollux.convert(to: .ecliptical(at: .J2000), positionType: .meanPosition)
        let λ_pollux = try ecl_pollux.sphericalCoordinates.longitude.convert(to: .degree)
        let β_pollux = try ecl_pollux.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(λ_pollux.scalarValue, 113.215630, accuracy: 0.000002)
        XCTAssertEqual(β_pollux.scalarValue, 6.684169786068421, accuracy: 0.000002)
    }
    
    func testEquatorialToEclipticalReciprocal() throws {
        let α_pollux = try Longitude(116.328942, unit: .degree)
        let δ_pollux = try Latitude(28.026183, unit: .degree)
        let eq_pollux = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α_pollux, latitude: δ_pollux), system: .equatorialJ2000, positionType: .meanPosition)
        let ecl_pollux = try eq_pollux.convert(to: .ecliptical(at: .J2000), positionType: .meanPosition)
        let eq_pollux2 = try ecl_pollux.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let α_pollux2 = try eq_pollux2.sphericalCoordinates.longitude.convert(to: .degree)
        let δ_pollux2 = try eq_pollux2.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(α_pollux2.scalarValue, α_pollux.scalarValue, accuracy: 0.000002)
        XCTAssertEqual(δ_pollux2.scalarValue, δ_pollux.scalarValue, accuracy: 0.000002)
    }
}
