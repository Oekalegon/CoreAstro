//
//  Planets.swift
//  
//
//  Created by Don Willems on 21/11/2021.
//

import Foundation

public class Planet : SolarSystemObject {
    
    public static let mercury = Planet(name: "Mercury")
    public static let venus = Planet(name: "Venus")
    public static let earth = Planet(name: "Earth")
    public static let mars = Planet(name: "Mars")
    public static let jupiter = Planet(name: "Jupiter")
    public static let saturn = Planet(name: "Saturn")
    public static let uranus = Planet(name: "Uranus")
    public static let neptune = Planet(name: "Neptune")
    
    private let vsop : VSOPFile
    
    private init(name: String) {
        self.vsop = VSOP.shared[name]!
        self._names.append(StringLiteral(string: name, language: "en"))
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
    
    public func equatorialCoordinates(on date: Date) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .ICRS, positionType: .meanPosition)
    }
    
    public func equatorialCoordinates(on date: Date, equinox: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .equatorial(for: equinox, from: location), positionType: .meanPosition)
    }
    
    public func galacticCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .galactic, positionType: .meanPosition)
    }
    
    public func eclipticalCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .ecliptical(at: date, from: location), positionType: .meanPosition)
    }
    
    public func horizontalCoordinates(on date: Date, from location: GeographicalLocation) -> Coordinates {
        return try! vsop.coordinates(on: date).convert(to: .horizontal(at: date, for: location), positionType: .meanPosition)
    }
    
}
