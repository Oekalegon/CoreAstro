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
        let λ = try Longitude(measure: ecl.sphericalCoordinates.longitude.convert(to: .degree))
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
    
    func testEquatorialToGalacticZero() throws {
        let α = try Longitude(266.40508920, unit: .degree)
        let δ = try Latitude(-28.93617470, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let gal = try eq.convert(to: .galactic, positionType: .meanPosition)
        let l = try Longitude(measure: gal.sphericalCoordinates.longitude.convert(to: .degree))
        let b = try gal.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(l, try! Longitude(0, unit: .degree))
        XCTAssertEqual(b.scalarValue, 0.0, accuracy: 0.0001)
        
        let eqr = try gal.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let αr = try Longitude(measure: eqr.sphericalCoordinates.longitude.convert(to: .degree))
        let δr = try eqr.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(α.scalarValue, αr.scalarValue, accuracy: 0.000001)
        XCTAssertEqual(δ.scalarValue, δr.scalarValue, accuracy: 0.000001)
    }
    
    func testEquatorialToGalactic() throws {
        let α_M51 = try Longitude(202.469575, unit: .degree)
        let δ_M51 = try Latitude(47.1952583333, unit: .degree)
        let eq_M51 = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α_M51, latitude: δ_M51), system: .equatorialJ2000, positionType: .meanPosition)
        let gal_M51 = try eq_M51.convert(to: .galactic, positionType: .meanPosition)
        let l_M51 = try Longitude(measure: gal_M51.sphericalCoordinates.longitude.convert(to: .degree))
        let b_M51 = try gal_M51.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(l_M51.scalarValue, try! Longitude(104.851585, unit: .degree).scalarValue, accuracy: 0.0001)
        XCTAssertEqual(b_M51.scalarValue, 68.560702, accuracy: 0.0001)
        
        let eq_M51r = try gal_M51.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let α_M51r = try Longitude(measure: eq_M51r.sphericalCoordinates.longitude.convert(to: .degree))
        let δ_M51r = try eq_M51r.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(α_M51.scalarValue, α_M51r.scalarValue, accuracy: 0.000001)
        XCTAssertEqual(δ_M51.scalarValue, δ_M51r.scalarValue, accuracy: 0.000001)
    }
    
    func testEquatorialToHorizontalNCP() throws {
        let date = Date()
        let location = GeographicalLocation(longitude: try Longitude(-10, unit: .degree), latitude: try Latitude(60, unit: .degree), elevation: nil)
        
        let α_NCP = try Longitude(202.469575, unit: .degree)
        let δ_NCP = try Latitude(90, unit: .degree)
        let eq_NCP = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α_NCP, latitude: δ_NCP), system: .equatorialJ2000, positionType: .meanPosition)
        let hor_NCP = try eq_NCP.convert(to: .horizontal(at: date, for: location), positionType: .meanPosition)
        let A_NCP = try Longitude(measure: hor_NCP.sphericalCoordinates.longitude.convert(to: .degree))
        let h_NCP = try hor_NCP.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(A_NCP.scalarValue, try! Longitude(0, unit: .degree).scalarValue, accuracy: 0.0001)
        XCTAssertEqual(h_NCP.scalarValue, location.latitude.scalarValue, accuracy: 0.0001)
        
        let eq_NCPr = try hor_NCP.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let δ_NCPr = try eq_NCPr.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(δ_NCP.scalarValue, δ_NCPr.scalarValue, accuracy: 0.000001)
    }
    
    func testEquatorialToHorizontalSouth() throws {
        let date = Date()
        let location = GeographicalLocation(longitude: try Longitude(-10, unit: .degree), latitude: try Latitude(60, unit: .degree), elevation: nil)
        let θ = try SiderealTime(on: date, at: location, positionType: .meanPosition)
        
        let α = Longitude(angle: θ)
        let δ = try Latitude(0, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let hor = try eq.convert(to: .horizontal(at: date, for: location), positionType: .meanPosition)
        let A = try Longitude(measure: hor.sphericalCoordinates.longitude.convert(to: .degree))
        let h = try hor.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(A.scalarValue, try! Longitude(180, unit: .degree).scalarValue, accuracy: 0.0001)
        XCTAssertEqual(h.scalarValue, 90 - location.latitude.scalarValue, accuracy: 0.0001)
        
        let eqr = try hor.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let αr = try eqr.sphericalCoordinates.longitude.convert(to: .degree)
        let δr = try eqr.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(α.scalarValue, αr.scalarValue, accuracy: 0.000001)
        XCTAssertEqual(δ.scalarValue, δr.scalarValue, accuracy: 0.000001)
    }
    
    func testEquatorialToHorizontalEast() throws {
        let date = Date()
        let location = GeographicalLocation(longitude: try Longitude(-10, unit: .degree), latitude: try Latitude(60, unit: .degree), elevation: nil)
        let θ = try SiderealTime(on: date, at: location, positionType: .meanPosition)
        
        let α = try Longitude(θ.convert(to: .degree).scalarValue + 90.0, unit: .degree)
        let δ = try Latitude(0, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let hor = try eq.convert(to: .horizontal(at: date, for: location), positionType: .meanPosition)
        let A = try Longitude(measure: hor.sphericalCoordinates.longitude.convert(to: .degree))
        let h = try hor.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(A.scalarValue, try! Longitude(90, unit: .degree).scalarValue, accuracy: 0.0001)
        XCTAssertEqual(h.scalarValue, 0, accuracy: 0.0001)
        
        let eqr = try hor.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let αr = try eqr.sphericalCoordinates.longitude.convert(to: .degree)
        let δr = try eqr.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(α.scalarValue, αr.scalarValue, accuracy: 0.000001)
        XCTAssertEqual(δ.scalarValue, δr.scalarValue, accuracy: 0.000001)
    }
    
    func testEquatorialToHorizontalWest() throws {
        let date = Date()
        let location = GeographicalLocation(longitude: try Longitude(-10, unit: .degree), latitude: try Latitude(60, unit: .degree), elevation: nil)
        let θ = try SiderealTime(on: date, at: location, positionType: .meanPosition)
        
        let α = try Longitude(θ.convert(to: .degree).scalarValue - 90.0, unit: .degree)
        let δ = try Latitude(0, unit: .degree)
        let eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: .equatorialJ2000, positionType: .meanPosition)
        let hor = try eq.convert(to: .horizontal(at: date, for: location), positionType: .meanPosition)
        let A = try Longitude(measure: hor.sphericalCoordinates.longitude.convert(to: .degree))
        let h = try hor.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(A.scalarValue, try! Longitude(270, unit: .degree).scalarValue, accuracy: 0.0001)
        XCTAssertEqual(h.scalarValue, 0, accuracy: 0.0001)
        
        let eqr = try hor.convert(to: .equatorialJ2000, positionType: .meanPosition)
        let αr = try eqr.sphericalCoordinates.longitude.convert(to: .degree)
        let δr = try eqr.sphericalCoordinates.latitude.convert(to: .degree)
        XCTAssertEqual(α.scalarValue, αr.scalarValue, accuracy: 0.000001)
        XCTAssertEqual(δ.scalarValue, δr.scalarValue, accuracy: 0.000001)
    }
}
