//
//  Constellations.swift
//  
//
//  Created by Don Willems on 28/11/2021.
//

import Foundation
import CoreMeasure


/// Instances of this structure represents a constellation. To get access to a specific constellation use the
/// properties, methods and subscripts available via the `Constellations` structure, or access the
/// constellation from a specific set of coordinates or a celestial object at a specific date.
public struct Constellation : Decodable, CustomStringConvertible {
    
    /// The (latin) name of the constellation
    public let name: String
    
    /// The genitive form of the constellation name.
    public let genitive: String
    
    /// A dictionary containing the abbreviations for the constellation,
    ///
    /// Keys correspond to the type of abbreviation. The most common type of abbreviation is the IAU
    /// type, using three characters to specify the constellation. Another type would be from NASA, using
    /// four characters.
    public let abbreviations: [String: String]
    
    /// The origin of the constellation, such as ancient or from a specific source (e.g. Keyser and de Houtman).
    public let origin: ConstellationOrigin
    
    /// The IAU abbreviation for this constellation, being the most common type of abbreviation.
    /// If the constellation is not an IAU constellation, the value will be `nil`.
    public var abbreviation: String? {
        return abbreviations["IAU"]
    }
    
    /// A string description of this constellation, either the IAU abbreviation or the name of the constellation
    /// if this is not an IAU constellation.
    public var description: String {
        return abbreviation != nil ? abbreviation! : name
    }
    
    /// Tests whether the specified coordinates are located in this constellation.
    /// - Parameter coordinates: The coordinates to be tested.
    /// - Returns: `true` when  the constellation contains the coordinates, `false`otherwise.
    public func contains(coordinates: Coordinates) -> Bool {
        return Constellations.all[coordinates]?.abbreviation == self.abbreviation
    }
}

/// Contains data about the origin of the constellation.
///
/// A constellation may be either ancient, or modern. If modern, the year when the constellation was created
/// may be included. Other information may be the source (i.e. publication and/or authors) and whether the
/// constellation was created from another constellation.
public struct ConstellationOrigin : Decodable {
    
    /// A flag specifying whether the constellation is an ancient  (`true`) or a modern (`false`)
    /// constellation.
    public let ancient: Bool
    
    /// The year when the constellation was created if known (otherwise, `nil`).
    public let year: Int?
    
    /// The source of the constellation (either a person, or a publication) that first mentions the constellation.
    public let source: String
    
    /// The precursor constellation to this constellation.
    public let precursor: ConstellationOriginPrecursor?
}

/// This struct contains information about the percursor of this constellation.
public struct ConstellationOriginPrecursor: Decodable {
    
    /// The name of the precursor.
    public let name: String
    
    /// A flag specifying whether the constellation is part of the precursor constellation.
    public let partOf: Bool
}

/// Contains metadata about the constellation file.
fileprivate struct ConstellationsFile: Decodable {
    
    /// The version of the constellation file.
    public let version: String
    
    /// The source URL of the constellation data.
    public let source: String
    
    /// An array containing all constellations.
    public let constellations: [Constellation]
}

/// A struct holding information about a constellation boundary as used by Roman, N.G, 1987
/// *Identification of a Constellation from a Position*
///  (https://cdsarc.u-strasbg.fr/ftp/VI/42/ReadMe)
///
/// The boundaries of a constellation are defined only on arcs parallel with the celestial equator, and are
/// defined by the minimal and maximal value in right ascension and the declination of the boundary.
fileprivate struct ConstellationBoundary {
    
    /// The minimal right ascension.
    let minRA: Double
    
    /// The maximal right ascension.
    let maxRA: Double
    
    /// The declination of the boundary arc.
    let minDEC: Double
    
    /// The abbreviation of the contellation to which the boundary belongs.
    let constellationAbbreviation: String
    
    /// Initialises the boundary from a line in the constellation boundary file `constellations.dat` in
    /// the `Resources` folder.
    /// - Parameter line: A line in the boundary file.
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
    
    /// Detemines whether the specified equatorial coordinates are within the range of the boundary arc.
    /// - Parameters:
    ///   - ra: The right ascension of the coordinates.
    ///   - dec: The declination of the coordinates.
    /// - Returns: `true` when the coordinates are within the range of the boundary, `false` otherwise.
    func coordinatesInBoundary(ra: Double, dec: Double) -> Bool {
        return ra >= self.minRA && ra < self.maxRA && dec >= self.minDEC
    }
}

/// This structure provides access to the different constellations.
///
/// To get access to a specific constellation, you can use one of the subscripts that are allowed for an instance
/// of this struct. Only one instance is allowed, however, and this instance can be accessed via
/// `Constellations.all`:
/// * You can use an integer subscipt to get the constellation at the specified index (in alphabetic order):
///   `Constellations.all[0]` returns Andromeda.
/// * You can us one of its abbreviations as an index:  `Constellation.all["Ori"]` returns
///    Orion.
/// * You can also use coordinates as an index: `Constellation.all[myCoordinates]`, which
///   returns the constellation which contains the specified coordinates.
public struct Constellations {
    
    // MARK - Static function to access constellations
    
    /// The coordinate system (geocentric equatorial at equinox B1875) for which the  constellation
    /// boundaries are defined.
    private static let catalogueCoordinateSystem = CoordinateSystem.equatorial(for: Date(besselianYear: 1875), from: .geocentric)
    
    private var _constellations = [Constellation]()
    
    /// Provides access to the constellations. Constellations can be accessed using subscripts to this
    /// object.
    ///
    /// Usage:
    /// * You can use an integer subscipt to get the constellation at the specified index (in alphabetic order):
    ///   `Constellations.all[0]` returns Andromeda.
    /// * You can us one of its abbreviations as an index:  `Constellation.all["Ori"]` returns
    ///    Orion.
    /// * You can also use coordinates as an index: `Constellation.all[myCoordinates]`, which
    ///   returns the constellation which contains the specified coordinates.
    ///
    public static let all = Constellations()
    
    /// The constellation at the specified integer index in alphabetic order.
    /// - Parameter index: The integer index.
    /// - Returns: The constellation at the specified index, or `nil` when the index is outside of
    /// the range.
    public subscript(index: Int) -> Constellation? {
        if index<0 || index >= _constellations.count {
            return nil
        }
        return _constellations[index]
    }
    
    /// The number of constellations.
    public var count : Int {
        get {
            return _constellations.count
        }
    }
    
    /// The constellation with the specified abbreviation, name or genitive as index.
    /// - Parameter key: The abbreviation, name or genitive.
    /// - Returns: The constellation with the specified index, or `nil` when the key is unknown.
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
    
    /// Detemines the constellation that contains the specified coordinates.
    ///
    /// This method is equivalent to the subscript using the coordinates as the index:
    /// `Constellations.all[coordinates]`.
    /// - Parameter coordinates: The coordinates for which the constellation needs to be determined.
    /// - Returns: The constellation containing the coordinates.
    public static func constellation(containing coordinates: Coordinates) -> Constellation {
        return Constellations.all[coordinates]!
    }
    
    
    /// The constellation that contains the coordinates that are used as the subscript.
    /// Usage: `Constellations.all[coordinates]`.
    ///
    /// This subscript is equivalent to this method:
    /// `Constellations.constellation(containing: coordinates)`.
    /// - Parameter coordinates: The coordinates for which the constellation needs to be determined.
    /// - Returns: The constellation containing the coordinates.
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
