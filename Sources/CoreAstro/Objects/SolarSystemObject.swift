//
//  SolarSystemObject.swift
//  
//
//  Created by Don Willems on 21/11/2021.
//

import Foundation
import CoreMeasure

public struct SolarSystem {
    
    public static let sun = Sun()
    
    /// An array containing all planets
    public static let planets = [Planet.mercury, Planet.venus, Planet.earth, Planet.mars, Planet.jupiter, Planet.saturn, Planet.uranus, Planet.neptune]
    
}

/// Object that adhere to this protocol represent objects in the Solar System
public protocol SolarSystemObject : CelestialObject {
}

/// Object that adhere to this protocol represent objects in the Solar System
public class VSOPObject : SolarSystemObject {
    
    
    let vsop : VSOPFile
    
    init(name: String) {
        self.vsop = VSOP.shared[name]!
        self._names.append(StringLiteral(name, language: "en"))
    }
    
    public var name: String? {
        get {
            var name: String? = nil
            var nameLang: String? = nil
            var nameEn: String? = nil
            var nameNoLanguage: String? = nil
            for nameLiteral in names {
                // TODO: Do something with locale (language)
                // >> Set `nameLang` to the name if the language is the locale
                // language
                if name == nil {
                    // First name encountered in array
                    name = nameLiteral.string
                }
                if nameLiteral.language == nil && nameNoLanguage == nil {
                    // First name encountered in array with a nil language
                    nameNoLanguage = nameLiteral.string
                } else if nameLiteral.language == "en" && nameEn == nil {
                    // First name encountered in array in English
                    nameEn = nameLiteral.string
                }
            }
            // Order of preferrence: name in locale language, name without a
            // language set, name in the English language, the first name in the
            // array of names.
            if nameLang != nil {
                return nameLang
            }
            if nameNoLanguage != nil {
                return nameNoLanguage
            }
            if nameEn != nil {
                return nameEn
            }
            return name
        }
    }
    
    private var _names = [StringLiteral]()
    
    public var names: [StringLiteral] {
        get {
            return _names
        }
    }
    
    public func names(language: String?) -> [String] {
        var namesRet = [String]()
        for nameliteral in names {
            if nameliteral.language == language {
                namesRet.append(nameliteral.string)
            }
        }
        return namesRet
    }
    
    public var types: [CelestialObjectType] {
        get {
            return [.solarSystemObject]
        }
    }
    
    public func isOfType(_ type: CelestialObjectType) -> Bool {
        for objectType in types {
            if objectType.rawValue.contains(type.rawValue) {
                return true
            }
        }
        return false
    }
    
    public func equatorialCoordinates(on date: Date) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .ICRS, positionType: .meanPosition)
    }
    
    public func equatorialCoordinates(on date: Date, equinox: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .equatorial(for: equinox, from: location), positionType: .meanPosition)
    }
    
    public func galacticCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .galactic, positionType: .meanPosition)
    }
    
    public func eclipticalCoordinates(on date: Date, eclipticAt ecliptic: Date? = nil, for equinox: Date? = nil, from location: CoordinateSystemOrigin) -> Coordinates {
        var equinoxDate = date
        if equinox != nil {
            equinoxDate = equinox!
        }
        var eclipticDate = date
        if ecliptic != nil {
            eclipticDate = ecliptic!
        }
        return try! vsop.coordinates(on: date).convert(to: .ecliptical(eclipticAt: eclipticDate, for: equinoxDate, from: location), positionType: .meanPosition)
    }
    
    public func horizontalCoordinates(on date: Date, from location: GeographicalLocation) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .horizontal(at: date, for: location), positionType: .meanPosition)
    }
    
    public func constellation(on date: Date) -> Constellation {
        let coord = vsop.coordinates(on: date)
        return Constellations.constellation(containing: coord)
    }
    
    public func elongation(on date: Date, from origin: CoordinateSystemOrigin) -> Angle {
        let sun = SolarSystem.sun.eclipticalCoordinates(on: date, from: origin)
        let coord = self.eclipticalCoordinates(on: date, from: origin)
        let separation = try! Coordinates.angularSeparation(between: coord, and: sun)
        return separation
    }
    
}

public class Sun : VSOPObject, Star {
    
    public override var types: [CelestialObjectType] {
        get {
            return [.solarSystemObject, .star]
        }
    }
    
    fileprivate init() {
        super.init(name: "Sun")
    }
    
}

struct VSOP {
    
    private static var files = [String: VSOPFile]()
    
    subscript(name: String) -> VSOPFile? {
        get {
            if VSOP.files[name] == nil {
                VSOP.files[name] = VSOPFile(name: name)
            }
            return VSOP.files[name]
        }
    }
    
    static let shared = VSOP()
}


class VSOPFile {
    
    private var records = [VSOPRecord]()
    
    fileprivate init(name: String) {
        let ext = String(name.lowercased()[..<name.index(name.startIndex, offsetBy: 3)])
        let vsopURL = Bundle.module.url(forResource: "VSOP87E", withExtension: ext)
        self.load(from: vsopURL!)
    }
    
    private func load(from url: URL) {
        let data = try! String(contentsOf: url, encoding: .utf8)
        let content = data.components(separatedBy: .newlines)
        var tPower = 0
        for line in content {
            let record = VSOPRecord(line: line)
            if record != nil {
                records.append(record!)
            } else {
                tPower = tPower + 1
            }
        }
    }
    
    func coordinates(on date: Date) -> Coordinates {
        // TODO: Calculation of Terestial Time
        let JD = date.julianDay.scalarValue
        let dTapprox = (67.6439 / 115.0) * (100 + (JD - 2451545)/365.25)
        let JDE = JD + dTapprox / 86400.0 // TO CONVERT TO Terestial Time
        let T = (JDE - 2451545) / 365250 // Julian Millenia
        var terms = [[Double]]()
        for record in records {
            let componentIndex = record.component.rawValue-1
            while terms.count <= componentIndex {
                terms.append([Double]())
            }
            while terms[componentIndex].count <= record.tPower {
                terms[componentIndex].append(0.0)
            }
            terms[componentIndex][record.tPower] = terms[componentIndex][record.tPower] + record.A*cos(record.B+record.C*T)
        }
        var component = 0
        var X = 0.0
        var Y = 0.0
        var Z = 0.0
        for termsPerComponent in terms {
            var componentValue = 0.0
            for tpow in 0..<termsPerComponent.count {
                componentValue = componentValue + termsPerComponent[tpow] * pow(T,Double(tpow))
            }
            switch component {
            case 0:
                X = componentValue
            case 1:
                Y = componentValue
            case 2:
                Z = componentValue
            default:
                break
            }
            component = component + 1
        }
        let rectComponents = try! RectangularCoordinates(x: Distance(X, unit: .astronomicalUnit), y: Distance(Y, unit: .astronomicalUnit), z: Distance(Z, unit: .astronomicalUnit))
        let coord = Coordinates(rectangularCoordinates: rectComponents, system: .ecliptical(eclipticAt: .J2000, for: .J2000, from: .barycentric), positionType: .meanPosition)
        
        // TODO: Correction for light time
        return coord
    }
}

struct VSOPRecord {
    
    enum VSOPComponent : Int {
        case X = 1
        case Y = 2
        case Z = 3
    }
    
    let component: VSOPComponent
    let tPower: Int
    let A: Double
    let B: Double
    let C: Double
    
    
    fileprivate init?(line: String) {
        if line.trimmingCharacters(in: .whitespaces) == "" {
            return nil
        }
        var components = [String]()
        var currentIndex = line.startIndex
        var range = currentIndex..<line.index(currentIndex, offsetBy: 5)
        let comp1 = String(line[range]).trimmingCharacters(in: .whitespaces)
        if comp1 == "VSOP" {
            return nil
        }
        components.append(comp1)
        currentIndex = line.index(range.upperBound, offsetBy: 2)
        for _ in 0..<13 {
            range = currentIndex..<line.index(currentIndex, offsetBy: 3)
            components.append(String(line[range]))
            currentIndex = range.upperBound
        }
        range = currentIndex..<line.index(currentIndex, offsetBy: 15)
        components.append(String(line[range]))
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 18)
        components.append(String(line[range]))
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 18)
        components.append(String(line[range]))
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 14)
        components.append(String(line[range]))
        currentIndex = range.upperBound
        range = currentIndex..<line.index(currentIndex, offsetBy: 20)
        components.append(String(line[range]))
        currentIndex = range.upperBound
        
        self.tPower = Int(components[0])! % 10
        let tcomp = Int(components[0])! / 10 % 10
        switch tcomp {
        case 1:
            self.component = .X
        case 2:
            self.component = .Y
        case 3:
            self.component = .Z
        default:
            self.component = .X
        }
        self.A = Double(components[16].trimmingCharacters(in: .whitespaces))!
        self.B = Double(components[17].trimmingCharacters(in: .whitespaces))!
        self.C = Double(components[18].trimmingCharacters(in: .whitespaces))!
        //print("component: \(self.component) t^\(self.tPower) A=\(self.A) B=\(self.B) C=\(self.C)")
    }
}
