//
//  Constellations.swift
//  
//
//  Created by Don Willems on 28/11/2021.
//

import Foundation
import CoreMeasure

public struct Constellation : Decodable, CustomStringConvertible {
    
    public let name: String
    public let genitive: String
    public let abbreviations: [String: String]
    public let origin: ConstellationOrigin
    
    public var abbreviation: String? {
        return abbreviations["IAU"]
    }
    
    public var description: String {
        return abbreviation != nil ? abbreviation! : name
    }
    
    public func contains(coordinates: Coordinates) -> Bool {
        return Constellations.all[coordinates]?.abbreviation == self.abbreviation
    }
}

public struct ConstellationOrigin : Decodable {
    public let ancient: Bool
    public let year: Int?
    public let source: String
    public let precursor: ConstellationOriginPrecursor?
}

public struct ConstellationOriginPrecursor: Decodable {
    public let name: String
    public let partOf: Bool
}

fileprivate struct ConstellationsFile: Decodable {
    public let version: String
    public let source: String
    public let constellations: [Constellation]
}

fileprivate struct ConstellationBoundary {
    
    let minRA: Double
    let maxRA: Double
    let minDEC: Double
    let constellationAbbreviation: String
    
    init(line: String) {
        var currentIndex = line.startIndex
        var range = currentIndex..<line.index(currentIndex, offsetBy: 8)
        self.minRA = Double(Int(Double(line[range].trimmingCharacters(in: .whitespacesAndNewlines))! * 60.0)) * 0.25
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 8)
        self.maxRA = Double(Int(Double(line[range].trimmingCharacters(in: .whitespacesAndNewlines))! * 60.0)) * 0.25
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 9)
        self.minDEC = Double(line[range].trimmingCharacters(in: .whitespacesAndNewlines))!
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 4)
        self.constellationAbbreviation = String(line[range]).trimmingCharacters(in: .whitespaces)
        //print("Boundary: \(self.minRA) \(self.maxRA) \(self.minDEC) -> \(self.constellationAbbreviation)")
    }
    
    func coordinatesInBoundary(ra: Double, dec: Double) -> Bool {
        return ra >= self.minRA && ra < self.maxRA && dec >= self.minDEC
    }
}

public struct Constellations {
    
    // MARK - Static function to access constellations
    
    private static let catalogueCoordinateSystem = CoordinateSystem.equatorial(for: Date(besselianYear: 1875), from: .geocentric)
    
    private var _constellations = [Constellation]()
    
    public static let all = Constellations()
    
    public subscript(index: Int) -> Constellation? {
        if index<0 || index >= _constellations.count {
            return nil
        }
        return _constellations[index]
    }
    
    public subscript(key: String) -> Constellation? {
        for constellation in _constellations {
            if constellation.abbreviations.values.contains(key) {
                return constellation
            }
            if constellation.name.lowercased() == key.lowercased() {
                return constellation
            }
            if constellation.genitive.lowercased() == key.lowercased() {
                return constellation
            }
        }
        return nil
    }
    
    public static func constellation(containing coordinates: Coordinates) -> Constellation {
        return Constellations.all[coordinates]!
    }
    
    public subscript(coordinates: Coordinates) -> Constellation? {
        let coord = try! coordinates.convert(to: Constellations.catalogueCoordinateSystem, positionType: .truePosition)
        let ra = try! coord.longitude.convert(to: .degree).scalarValue
        let dec = try! coord.latitude.convert(to: .degree).scalarValue
        for boundary in constellationBoundaries {
            if boundary.coordinatesInBoundary(ra: ra, dec: dec) {
                let abbreviation = boundary.constellationAbbreviation
                return self[abbreviation]
            }
        }
        return nil
    }
    
    private var constellationBoundaries = [ConstellationBoundary]()
    
    private init() {
        loadConstellations()
    }
    
    private mutating func readConstellationsFile() {
        let constellationsFileURL = Bundle.module.url(forResource: "constellations", withExtension: "json")
        let JSON = try! String(contentsOf: constellationsFileURL!, encoding: .utf8)
        let jsonData = JSON.data(using: .utf8)!
        let constellationsData: ConstellationsFile = try! JSONDecoder().decode(ConstellationsFile.self, from: jsonData)
        _constellations.append(contentsOf: constellationsData.constellations)
        
    }
    
    private mutating func readConstellationsDataFile() {
        let constellationsDataFileURL = Bundle.module.url(forResource: "constellations", withExtension: "dat")
        let data = try! String(contentsOf: constellationsDataFileURL!, encoding: .utf8)
        let content = data.components(separatedBy: .newlines)
        for line in content {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                constellationBoundaries.append(ConstellationBoundary(line: line))
            }
        }
    }
    
    private mutating func loadConstellations() {
        self.readConstellationsFile()
        self.readConstellationsDataFile()
    }
}
