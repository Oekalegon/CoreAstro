//
//  ConstellationsTests.swift
//  
//
//  Created by Don Willems on 28/11/2021.
//

import Foundation
import XCTest
import CoreMeasure
@testable import CoreAstro

final class ConstellationsTests: XCTestCase {
    
    private let catalogueCoordinateSystem = CoordinateSystem.equatorial(for: Date(besselianYear: 1875), from: .geocentric)
    
    func testConstellationsLoading() throws {
        let And = Constellations.all["And"]
        XCTAssertNotNil(And)
        XCTAssertEqual(And!.name, "Andromeda")
        
        let CMi = Constellations.all["canis minoris"]
        XCTAssertNotNil(CMi)
        XCTAssertEqual(CMi!.name, "Canis Minor")
    }
    
    func testCoordinatesInConstellation() throws {
        var α = try Longitude(9.0*15.0, unit: .degree)
        var δ = try Latitude(65.0, unit: .degree)
        var eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.all[eq]?.abbreviation, "UMa")
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "UMa")
        XCTAssertTrue(Constellations.all["UMa"]!.contains(coordinates: eq))
        
        α = try Longitude(23.5*15.0, unit: .degree)
        δ = try Latitude(-20.0, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Aqr")
        XCTAssertTrue(Constellations.all["Aqr"]!.contains(coordinates: eq))
        
        α = try Longitude(5.12*15.0, unit: .degree)
        δ = try Latitude(9.12, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Ori")
        XCTAssertTrue(Constellations.all["Ori"]!.contains(coordinates: eq))
        
        α = try Longitude(9.4555*15.0, unit: .degree)
        δ = try Latitude(-19.9, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Hya")
        XCTAssertTrue(Constellations.all["Hya"]!.contains(coordinates: eq))
        
        α = try Longitude(12.8888*15.0, unit: .degree)
        δ = try Latitude(22.0, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Com")
        XCTAssertTrue(Constellations.all["Com"]!.contains(coordinates: eq))
        
        α = try Longitude(15.6687*15.0, unit: .degree)
        δ = try Latitude(-12.1234, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Lib")
        XCTAssertTrue(Constellations.all["Lib"]!.contains(coordinates: eq))
        
        α = try Longitude(19.0*15.0, unit: .degree)
        δ = try Latitude(-40.0, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "CrA")
        XCTAssertTrue(Constellations.all["CrA"]!.contains(coordinates: eq))
        
        α = try Longitude(6.2222*15.0, unit: .degree)
        δ = try Latitude(-81.1234, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Men")
        XCTAssertTrue(Constellations.all["Men"]!.contains(coordinates: eq))
        
        α = try Longitude(15.32344, unit: .degree)
        δ = try Latitude(-90.0, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "Oct")
        XCTAssertTrue(Constellations.all["Oct"]!.contains(coordinates: eq))
        
        α = try Longitude(2.33453, unit: .degree)
        δ = try Latitude(90.0, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "UMi")
        XCTAssertTrue(Constellations.all["UMi"]!.contains(coordinates: eq))
        
        α = try Longitude(3132.33453, unit: .degree)
        δ = try Latitude(90.0, unit: .degree)
        eq = Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: α, latitude: δ), system: catalogueCoordinateSystem, positionType: .meanPosition)
        XCTAssertEqual(Constellations.constellation(containing: eq).abbreviation, "UMi")
        XCTAssertTrue(Constellations.all["UMi"]!.contains(coordinates: eq))
    }
}
