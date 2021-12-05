//
//  CatalogTests.swift
//  
//
//  Created by Don Willems on 30/11/2021.
//

import Foundation

import XCTest
import CoreMeasure
@testable import CoreAstro

final class CatalogTests: XCTestCase {
    
    func testBSCCatalog() throws {
        let bsc = BrightStarCatalog.catalog
    }
    
    func testObjectSearch() throws {
        let results = CelestialObjectSearch.shared.search(string: "ven")
        for result in results {
            print("\(result)")
        }
    }
    
    func testObjectAreaSearch() throws {
        let results = CelestialObjectSearch.shared.search(minRA: 0*15, maxRA: 24*15, minDec: 85.0, maxDec: 90.0)
        for result in results {
            print("\(result)")
        }
    }
}
