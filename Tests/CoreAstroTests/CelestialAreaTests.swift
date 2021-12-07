//
//  CelestialAreaTests.swift
//  
//
//  Created by Don Willems on 23/05/2021.
//

import XCTest
@testable import CoreAstro

class CelestialAreaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntersectionEquirectangularCoordinates1() throws {
        let sw1 = try Coordinates.equatorialCoordinates(rightAscension: 12.3*15, declination: +12)
        let ne1 = try Coordinates.equatorialCoordinates(rightAscension: 12.7*15, declination: +13)
        let area1 = try EquirectangularCelestialArea(southWest: sw1, northEast: ne1)
        let sw2 = try Coordinates.equatorialCoordinates(rightAscension: 12.6*15, declination: +12.5)
        let ne2 = try Coordinates.equatorialCoordinates(rightAscension: 12.9*15, declination: +13.2)
        let area2 = try EquirectangularCelestialArea(southWest: sw2, northEast: ne2)
        XCTAssertTrue(area1.intersects(with: area2))
        
        let sw3 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +12.5)
        let ne3 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +13.2)
        let area3 = try EquirectangularCelestialArea(southWest: sw3, northEast: ne3)
        XCTAssertTrue(area1.intersects(with: area3))
        
        let sw4 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +12.5)
        let ne4 = try Coordinates.equatorialCoordinates(rightAscension: 12.6*15, declination: +13.2)
        let area4 = try EquirectangularCelestialArea(southWest: sw4, northEast: ne4)
        XCTAssertTrue(area1.intersects(with: area4))
        
        let sw5 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +12.5)
        let ne5 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +13.2)
        let area5 = try EquirectangularCelestialArea(southWest: sw5, northEast: ne5)
        XCTAssertTrue(area1.intersects(with: area5))
        
        let sw6 = try Coordinates.equatorialCoordinates(rightAscension: 11.8*15, declination: +12.5)
        let ne6 = try Coordinates.equatorialCoordinates(rightAscension: 12.2*15, declination: +13.2)
        let area6 = try EquirectangularCelestialArea(southWest: sw6, northEast: ne6)
        XCTAssertFalse(area1.intersects(with: area6))
        
        let sw7 = try Coordinates.equatorialCoordinates(rightAscension: 13.0*15, declination: +12.5)
        let ne7 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +13.2)
        let area7 = try EquirectangularCelestialArea(southWest: sw7, northEast: ne7)
        XCTAssertFalse(area1.intersects(with: area7))
        
        let sw8 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +11)
        let ne8 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +12.2)
        let area8 = try EquirectangularCelestialArea(southWest: sw8, northEast: ne8)
        XCTAssertTrue(area1.intersects(with: area8))
        
        let sw9 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +12.2)
        let ne9 = try Coordinates.equatorialCoordinates(rightAscension: 12.6*15, declination: +12.4)
        let area9 = try EquirectangularCelestialArea(southWest: sw9, northEast: ne9)
        XCTAssertTrue(area1.intersects(with: area9))
        
        let sw10 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +11)
        let ne10 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +14)
        let area10 = try EquirectangularCelestialArea(southWest: sw10, northEast: ne10)
        XCTAssertTrue(area1.intersects(with: area10))
        
        let sw11 = try Coordinates.equatorialCoordinates(rightAscension: 11.8*15, declination: +13.5)
        let ne11 = try Coordinates.equatorialCoordinates(rightAscension: 12.2*15, declination: +13.9)
        let area11 = try EquirectangularCelestialArea(southWest: sw11, northEast: ne11)
        XCTAssertFalse(area1.intersects(with: area11))
        
        let sw12 = try Coordinates.equatorialCoordinates(rightAscension: 13.0*15, declination: +11.5)
        let ne12 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +11.9)
        let area12 = try EquirectangularCelestialArea(southWest: sw12, northEast: ne12)
        XCTAssertFalse(area1.intersects(with: area12))
    }
    
    func testIntersectionEquirectangularCoordinates2() throws {
        let sw1 = try Coordinates.equatorialCoordinates(rightAscension: 12.3*15, declination: +12)
        let ne1 = try Coordinates.equatorialCoordinates(rightAscension: 12.7*15, declination: +13)
        let area1 = try EquirectangularCelestialArea(southWest: sw1, northEast: ne1)
        let sw2 = try Coordinates.equatorialCoordinates(rightAscension: 12.6*15, declination: +12.5)
        let ne2 = try Coordinates.equatorialCoordinates(rightAscension: 12.9*15, declination: +13.2)
        let area2 = try EquirectangularCelestialArea(southWest: sw2, northEast: ne2)
        XCTAssertTrue(area2.intersects(with: area1))
        
        let sw3 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +12.5)
        let ne3 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +13.2)
        let area3 = try EquirectangularCelestialArea(southWest: sw3, northEast: ne3)
        XCTAssertTrue(area3.intersects(with: area1))
        
        let sw4 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +12.5)
        let ne4 = try Coordinates.equatorialCoordinates(rightAscension: 12.6*15, declination: +13.2)
        let area4 = try EquirectangularCelestialArea(southWest: sw4, northEast: ne4)
        XCTAssertTrue(area4.intersects(with: area1))
        
        let sw5 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +12.5)
        let ne5 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +13.2)
        let area5 = try EquirectangularCelestialArea(southWest: sw5, northEast: ne5)
        XCTAssertTrue(area5.intersects(with: area1))
        
        let sw6 = try Coordinates.equatorialCoordinates(rightAscension: 11.8*15, declination: +12.5)
        let ne6 = try Coordinates.equatorialCoordinates(rightAscension: 12.2*15, declination: +13.2)
        let area6 = try EquirectangularCelestialArea(southWest: sw6, northEast: ne6)
        XCTAssertFalse(area6.intersects(with: area1))
        
        let sw7 = try Coordinates.equatorialCoordinates(rightAscension: 13.0*15, declination: +12.5)
        let ne7 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +13.2)
        let area7 = try EquirectangularCelestialArea(southWest: sw7, northEast: ne7)
        XCTAssertFalse(area7.intersects(with: area1))
        
        let sw8 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +11)
        let ne8 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +12.2)
        let area8 = try EquirectangularCelestialArea(southWest: sw8, northEast: ne8)
        XCTAssertTrue(area8.intersects(with: area1))
        
        let sw9 = try Coordinates.equatorialCoordinates(rightAscension: 12.4*15, declination: +12.2)
        let ne9 = try Coordinates.equatorialCoordinates(rightAscension: 12.6*15, declination: +12.4)
        let area9 = try EquirectangularCelestialArea(southWest: sw9, northEast: ne9)
        XCTAssertTrue(area9.intersects(with: area1))
        
        let sw10 = try Coordinates.equatorialCoordinates(rightAscension: 12.0*15, declination: +11)
        let ne10 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +14)
        let area10 = try EquirectangularCelestialArea(southWest: sw10, northEast: ne10)
        XCTAssertTrue(area10.intersects(with: area1))
        
        let sw11 = try Coordinates.equatorialCoordinates(rightAscension: 11.8*15, declination: +13.5)
        let ne11 = try Coordinates.equatorialCoordinates(rightAscension: 12.2*15, declination: +13.9)
        let area11 = try EquirectangularCelestialArea(southWest: sw11, northEast: ne11)
        XCTAssertFalse(area11.intersects(with: area1))
        
        let sw12 = try Coordinates.equatorialCoordinates(rightAscension: 13.0*15, declination: +11.5)
        let ne12 = try Coordinates.equatorialCoordinates(rightAscension: 13.4*15, declination: +11.9)
        let area12 = try EquirectangularCelestialArea(southWest: sw12, northEast: ne12)
        XCTAssertFalse(area12.intersects(with: area1))
    }
    
    func testIntersectionEquirectangularCoordinatesWithZeroCrossing1() throws {
        let sw1 = try Coordinates.equatorialCoordinates(rightAscension: 22.5*15, declination: +12)
        let ne1 = try Coordinates.equatorialCoordinates(rightAscension: 1.5*15, declination: +13)
        let area1 = try EquirectangularCelestialArea(southWest: sw1, northEast: ne1)
        let sw2 = try Coordinates.equatorialCoordinates(rightAscension: 0.2*15, declination: +12.5)
        let ne2 = try Coordinates.equatorialCoordinates(rightAscension: 2*15, declination: +13.2)
        let area2 = try EquirectangularCelestialArea(southWest: sw2, northEast: ne2)
        XCTAssertTrue(area1.intersects(with: area2))
        
        let sw3 = try Coordinates.equatorialCoordinates(rightAscension: 0.1*15, declination: +12.5)
        let ne3 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +13.2)
        let area3 = try EquirectangularCelestialArea(southWest: sw3, northEast: ne3)
        XCTAssertTrue(area1.intersects(with: area3))
        
        let sw15 = try Coordinates.equatorialCoordinates(rightAscension: 0.1*15, declination: +12.5)
        let ne15 = try Coordinates.equatorialCoordinates(rightAscension: 5.5*15, declination: +13.2)
        let area15 = try EquirectangularCelestialArea(southWest: sw15, northEast: ne15)
        XCTAssertTrue(area1.intersects(with: area15))
        
        let sw16 = try Coordinates.equatorialCoordinates(rightAscension: 2.0*15, declination: +12.5)
        let ne16 = try Coordinates.equatorialCoordinates(rightAscension: 1.99*15, declination: +13.2)
        let area16 = try EquirectangularCelestialArea(southWest: sw16, northEast: ne16)
        XCTAssertTrue(area1.intersects(with: area16))
        
        let sw17 = try Coordinates.equatorialCoordinates(rightAscension: 0.4*15, declination: +12.5)
        let ne17 = try Coordinates.equatorialCoordinates(rightAscension: 0.3*15, declination: +13.2)
        let area17 = try EquirectangularCelestialArea(southWest: sw17, northEast: ne17)
        XCTAssertTrue(area3.intersects(with: area17))
        
        let sw4 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +12.5)
        let ne4 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +13.2)
        let area4 = try EquirectangularCelestialArea(southWest: sw4, northEast: ne4)
        XCTAssertTrue(area1.intersects(with: area4))
        
        let sw13 = try Coordinates.equatorialCoordinates(rightAscension: 20.5*15, declination: +12.5)
        let ne13 = try Coordinates.equatorialCoordinates(rightAscension: 4.5*15, declination: +13.2)
        let area13 = try EquirectangularCelestialArea(southWest: sw13, northEast: ne13)
        XCTAssertTrue(area1.intersects(with: area13))
        
        let sw5 = try Coordinates.equatorialCoordinates(rightAscension: 22.5*15, declination: +12.5)
        let ne5 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +13.2)
        let area5 = try EquirectangularCelestialArea(southWest: sw5, northEast: ne5)
        XCTAssertTrue(area1.intersects(with: area5))
        
        let sw6 = try Coordinates.equatorialCoordinates(rightAscension: 2*15, declination: +12.5)
        let ne6 = try Coordinates.equatorialCoordinates(rightAscension: 3*15, declination: +13.2)
        let area6 = try EquirectangularCelestialArea(southWest: sw6, northEast: ne6)
        XCTAssertFalse(area1.intersects(with: area6))
        
        let sw7 = try Coordinates.equatorialCoordinates(rightAscension: 22*15, declination: +12.5)
        let ne7 = try Coordinates.equatorialCoordinates(rightAscension: 22.3*15, declination: +13.2)
        let area7 = try EquirectangularCelestialArea(southWest: sw7, northEast: ne7)
        XCTAssertFalse(area1.intersects(with: area7))
        
        let sw8 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +11)
        let ne8 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +12.2)
        let area8 = try EquirectangularCelestialArea(southWest: sw8, northEast: ne8)
        XCTAssertTrue(area1.intersects(with: area8))
        
        let sw9 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +12.2)
        let ne9 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +12.4)
        let area9 = try EquirectangularCelestialArea(southWest: sw9, northEast: ne9)
        XCTAssertTrue(area1.intersects(with: area9))
        
        let sw10 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +11)
        let ne10 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +14)
        let area10 = try EquirectangularCelestialArea(southWest: sw10, northEast: ne10)
        XCTAssertTrue(area1.intersects(with: area10))
        
        let sw11 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +13.5)
        let ne11 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +13.9)
        let area11 = try EquirectangularCelestialArea(southWest: sw11, northEast: ne11)
        XCTAssertFalse(area1.intersects(with: area11))
        
        let sw12 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +11.5)
        let ne12 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +11.9)
        let area12 = try EquirectangularCelestialArea(southWest: sw12, northEast: ne12)
        XCTAssertFalse(area1.intersects(with: area12))
    }
    
    func testIntersectionEquirectangularCoordinatesWithZeroCrossing2() throws {
        let sw1 = try Coordinates.equatorialCoordinates(rightAscension: 22.5*15, declination: +12)
        let ne1 = try Coordinates.equatorialCoordinates(rightAscension: 1.5*15, declination: +13)
        let area1 = try EquirectangularCelestialArea(southWest: sw1, northEast: ne1)
        let sw2 = try Coordinates.equatorialCoordinates(rightAscension: 0.2*15, declination: +12.5)
        let ne2 = try Coordinates.equatorialCoordinates(rightAscension: 2*15, declination: +13.2)
        let area2 = try EquirectangularCelestialArea(southWest: sw2, northEast: ne2)
        XCTAssertTrue(area2.intersects(with: area1))
        
        let sw3 = try Coordinates.equatorialCoordinates(rightAscension: 0.1*15, declination: +12.5)
        let ne3 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +13.2)
        let area3 = try EquirectangularCelestialArea(southWest: sw3, northEast: ne3)
        XCTAssertTrue(area3.intersects(with: area1))
        
        let sw15 = try Coordinates.equatorialCoordinates(rightAscension: 0.1*15, declination: +12.5)
        let ne15 = try Coordinates.equatorialCoordinates(rightAscension: 5.5*15, declination: +13.2)
        let area15 = try EquirectangularCelestialArea(southWest: sw15, northEast: ne15)
        XCTAssertTrue(area15.intersects(with: area1))
        
        let sw16 = try Coordinates.equatorialCoordinates(rightAscension: 2.0*15, declination: +12.5)
        let ne16 = try Coordinates.equatorialCoordinates(rightAscension: 1.99*15, declination: +13.2)
        let area16 = try EquirectangularCelestialArea(southWest: sw16, northEast: ne16)
        XCTAssertTrue(area16.intersects(with: area1))
        
        let sw17 = try Coordinates.equatorialCoordinates(rightAscension: 0.4*15, declination: +12.5)
        let ne17 = try Coordinates.equatorialCoordinates(rightAscension: 0.3*15, declination: +13.2)
        let area17 = try EquirectangularCelestialArea(southWest: sw17, northEast: ne17)
        XCTAssertTrue(area17.intersects(with: area3))
        
        let sw4 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +12.5)
        let ne4 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +13.2)
        let area4 = try EquirectangularCelestialArea(southWest: sw4, northEast: ne4)
        XCTAssertTrue(area4.intersects(with: area1))
        
        let sw5 = try Coordinates.equatorialCoordinates(rightAscension: 22.0*15, declination: +12.5)
        let ne5 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +13.2)
        let area5 = try EquirectangularCelestialArea(southWest: sw5, northEast: ne5)
        XCTAssertTrue(area5.intersects(with: area1))
        
        let sw6 = try Coordinates.equatorialCoordinates(rightAscension: 2*15, declination: +12.5)
        let ne6 = try Coordinates.equatorialCoordinates(rightAscension: 3*15, declination: +13.2)
        let area6 = try EquirectangularCelestialArea(southWest: sw6, northEast: ne6)
        XCTAssertFalse(area6.intersects(with: area1))
        
        let sw7 = try Coordinates.equatorialCoordinates(rightAscension: 22*15, declination: +12.5)
        let ne7 = try Coordinates.equatorialCoordinates(rightAscension: 22.3*15, declination: +13.2)
        let area7 = try EquirectangularCelestialArea(southWest: sw7, northEast: ne7)
        XCTAssertFalse(area7.intersects(with: area1))
        
        let sw8 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +11)
        let ne8 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +12.2)
        let area8 = try EquirectangularCelestialArea(southWest: sw8, northEast: ne8)
        XCTAssertTrue(area8.intersects(with: area1))
        
        let sw9 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +12.2)
        let ne9 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +12.4)
        let area9 = try EquirectangularCelestialArea(southWest: sw9, northEast: ne9)
        XCTAssertTrue(area9.intersects(with: area1))
        
        let sw10 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +11)
        let ne10 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +14)
        let area10 = try EquirectangularCelestialArea(southWest: sw10, northEast: ne10)
        XCTAssertTrue(area10.intersects(with: area1))
        
        let sw11 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +13.5)
        let ne11 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +13.9)
        let area11 = try EquirectangularCelestialArea(southWest: sw11, northEast: ne11)
        XCTAssertFalse(area11.intersects(with: area1))
        
        let sw12 = try Coordinates.equatorialCoordinates(rightAscension: 23.5*15, declination: +11.5)
        let ne12 = try Coordinates.equatorialCoordinates(rightAscension: 0.5*15, declination: +11.9)
        let area12 = try EquirectangularCelestialArea(southWest: sw12, northEast: ne12)
        XCTAssertFalse(area12.intersects(with: area1))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
