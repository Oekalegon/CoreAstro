//
//  Catalog.swift
//  
//
//  Created by Don Willems on 29/11/2021.
//

import Foundation
import CoreMeasure

public protocol Catalog {
    
    /// The number of objects in the catalog
    var count: Int {get}
    
    /// The types of the celestial object contained in the catalog.
    var types: [CelestialObjectType] {get}
    
    /// The catalog object at the specified integer index.
    /// - Parameter index: The integer index.
    /// - Returns: The object at the specified index, or `nil` when the index is outside of
    /// the range.
    subscript(index: Int) -> CatalogObject? {get}
}

struct CatalogTextFileReader {
    
    private let url: URL
    private let catalogFile: CatalogFile
    
    init(url: URL) {
        self.url = url
        let JSON = try! String(contentsOf: url, encoding: .utf8)
        let jsonData = JSON.data(using: .utf8)!
        self.catalogFile = try! JSONDecoder().decode(CatalogFile.self, from: jsonData)
    }
    
    func load() -> [CatalogObject] {
        var objects = [CatalogObject]()
        for file in catalogFile.files {
            let fileURL = Bundle.module.url(forResource: (file.filename as NSString).deletingPathExtension, withExtension: (file.filename as NSString).pathExtension)
            let data = try! String(contentsOf: fileURL!, encoding: .utf8)
            let content = data.components(separatedBy: .newlines)
            for line in content {
                let object = self.readLine(file: file, line: line, defaultType: self.parseCelestialObjectType(value: catalogFile.defaultType))
                if object != nil {
                    objects.append(object!)
                }
            }
        }
        return objects
    }
    
    func readLine(file: CatalogTextFile, line: String, defaultType: CelestialObjectType?) -> CatalogObject? {
        var object : CatalogObject? = nil
        if line.trimmingCharacters(in: .whitespaces).count <= 0 {
            return object
        }
        var identifiers = [ObjectIdentifier]()
        var names = [StringLiteral]()
        var bayer: BayerDesignation? = nil
        var flamsteed: FlamsteedDesignation? = nil
        var variableStarDesignation: VariableStarDesignation? = nil
        var constellation: Constellation? = nil
        var objectTypes = [CelestialObjectType]()
        var coordinates: Coordinates? = nil
        if defaultType != nil {
            objectTypes.append(defaultType!)
        }
        for field in file.fields {
            let range = line.index(line.startIndex, offsetBy: field.startIndex-1)..<line.index(line.startIndex, offsetBy: field.endIndex)
            let value = String(line[range])
            //print("\t\t\(field.name): '\(value)'")
            if field.type == "ObjectIdentifier" {
                let identifier = self.parseObjectIdentifier(field: field, value: value)
                if identifier != nil {
                    identifiers.append(identifier!)
                }
            } else if field.type == "BayerFlamsteedName" {
                let bfn = self.parseBayerFlamsteedName(value: value)
                bayer = bfn?.bayer
                flamsteed = bfn?.flamsteed
                constellation = bfn?.constellation
                if bfn?.name != nil {
                    names.append(StringLiteral(bfn!.name!))
                }
            } else if field.type == "VariableStarDesignation" {
                variableStarDesignation = self.parseVariableStar(value: value)
                objectTypes.append(.variableStar)
            } else if field.type == "TypeFlag" {
                let flag = value.trimmingCharacters(in: .whitespaces)
                if field.typeData != nil && field.typeData![flag] != nil {
                    let objectType = parseCelestialObjectType(value: field.typeData![flag]!)
                    if objectType != nil {
                        objectTypes.append(objectType!)
                    }
                }
            } else if field.type == "EquatorialCoordinates" {
                coordinates = parseCoordinates(field: field, value:value)
            }
        }
        if objectTypes.contains(.star) && coordinates != nil {
            object = try! CatalogStar(names: names, bayer: bayer, flamsteed: flamsteed, variableStarDesignation: variableStarDesignation, identifiers: identifiers, types: objectTypes, coordinates: coordinates!, constellation: constellation)
            print(object!)
        } else {
            print("\n---")
            print("line: \(line)")
            print("names: \(names)")
            print("bayer: \(bayer)")
            print("flamsteed: \(flamsteed)")
            print("variable star: \(variableStarDesignation)")
            print("identifiers: \(identifiers)")
            print("constellation: \(constellation)")
            print("types: \(objectTypes)")
            print("coordinates: \(coordinates)")
        }
        return object
    }
    
    func parseCoordinates(field: CatalogTextFileField, value: String) -> Coordinates? {
        // TODO: Add distance
        // TODO: Use the epoch somewhere (used for proper motion and variables)
        var system: CoordinateSystem? = nil
        var longitude: Longitude? = nil
        var latitude: Latitude? = nil
        var distance: Distance? = nil
        let equinoxStr = field.equinox
        var equinox: Date? = nil
        if equinoxStr != nil {
            let prefix = equinoxStr!.prefix(1)
            if prefix == "J" {
                equinox = Date(julianYear: Double(equinoxStr!.dropFirst(1))!)
            } else if prefix == "B" {
                equinox = Date(besselianYear: Double(equinoxStr!.dropFirst(1))!)
            }
        }
        let epochStr = field.epoch
        var epoch: Date? = nil
        if epochStr != nil {
            let prefix = epochStr!.prefix(1)
            if prefix == "J" {
                epoch = Date(julianYear: Double(epochStr!.dropFirst(1))!)
            } else if prefix == "B" {
                epoch = Date(besselianYear: Double(epochStr!.dropFirst(1))!)
            }
        }
        for subfield in field.subfields! {
            let range = value.index(value.startIndex, offsetBy: subfield.startIndex-1)..<value.index(value.startIndex, offsetBy: subfield.endIndex)
            let subvalue = String(value[range])
            if subfield.type == "LongitudeHMS" {
                longitude = self.parseLongitudeHMS(field: subfield, value: subvalue)
            } else if subfield.type == "LatitudeSDMS" {
                latitude = self.parseLatitudeSDMS(field: subfield, value: subvalue)
            }
            if field.type == "EquatorialCoordinates" {
                if equinox != nil {
                    system = .equatorial(for: equinox!, from: .heliocentric)
                }
            }
        }
        if longitude != nil && latitude != nil && system != nil {
            return Coordinates(sphericalCoordinates: SphericalCoordinates(longitude: longitude!, latitude: latitude!, distance: distance), system: system!, positionType: .meanPosition)
        }
        return nil
    }
    
    func parseLongitudeHMS(field: CatalogTextFileField, value: String) -> Longitude? {
        var hours : Double? = 0.0
        var minutes : Double? = 0.0
        var seconds : Double? = 0.0
        for subfield in field.subfields! {
            let range = value.index(value.startIndex, offsetBy: subfield.startIndex-1)..<value.index(value.startIndex, offsetBy: subfield.endIndex)
            let subvalue = String(value[range])
            if subfield.type == "AngleH" {
                hours = Double(subvalue)
            } else if subfield.type == "AngleM" {
                minutes = Double(subvalue)
            } else if subfield.type == "AngleS" {
                seconds = Double(subvalue)
            }
        }
        if hours == nil {
            return nil
        }
        var angle = hours!*15.0
        if minutes != nil {
            angle = angle + minutes!*0.25
            if seconds != nil {
                angle = angle + seconds!*15.0/3600.0
            }
        }
        return try! Longitude(angle, unit: .degree)
    }
    
    func parseLatitudeSDMS(field: CatalogTextFileField, value: String) -> Latitude? {
        var sign = 1
        var degrees : Double? = 0.0
        var minutes : Double? = 0.0
        var seconds : Double? = 0.0
        for subfield in field.subfields! {
            let range = value.index(value.startIndex, offsetBy: subfield.startIndex-1)..<value.index(value.startIndex, offsetBy: subfield.endIndex)
            let subvalue = String(value[range])
            if subfield.type == "AngleSD" {
                degrees = Double(subvalue)
                if subvalue.starts(with: "-") {
                    sign = -1
                }
            } else if subfield.type == "AngleAM" {
                minutes = Double(subvalue)
            } else if subfield.type == "AngleAS" {
                seconds = Double(subvalue)
            }
        }
        if degrees == nil {
            return nil
        }
        var angle = degrees!
        if minutes != nil {
            angle = angle + Double(sign)*minutes!/60
            if seconds != nil {
                angle = angle + Double(sign)*seconds!/3600.0
            }
        }
        return try! Latitude(angle, unit: .degree)
    }
    
    func parseObjectIdentifier(field: CatalogTextFileField, value: String) -> ObjectIdentifier? {
        let identifier = value.trimmingCharacters(in: .whitespaces)
        if identifier.count > 0 {
            let catalogIndentifier = field.typeData!["catalogIdentifier"]!
            return ObjectIdentifier(identifier: identifier, catalogIdentifier: catalogIndentifier)
        }
        return nil
    }
    
    func parseCelestialObjectType(value: String) -> CelestialObjectType? {
        for type in CelestialObjectType.allCases {
            if value == type.rawValue {
                return type
            }
        }
        return nil
    }
    
    func parseBayerFlamsteedName(value: String) -> (name: String?, bayer: BayerDesignation?, flamsteed: FlamsteedDesignation?, constellation: Constellation?)? {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        if trimmed.count > 0 {
            var flamsteed: FlamsteedDesignation? = nil
            var bayer: BayerDesignation? = nil
            let flamsteedNumberRange = value.startIndex..<value.index(value.startIndex, offsetBy: 3)
            let bayerLetterRange = value.index(value.startIndex, offsetBy: 3)..<value.index(value.startIndex, offsetBy: 6)
            let bayerSuperScriptRange = value.index(trimmed.startIndex, offsetBy: 6)..<value.index(value.startIndex, offsetBy: 7)
            let constellationAbbreviationRange = value.index(trimmed.startIndex, offsetBy: 7)..<value.index(value.startIndex, offsetBy: 10)
            let constellationAbbreviation = String(value[constellationAbbreviationRange])
            var breakOut = false // Set to true when this cannot be a flamsteed/bayer designation
            let constellation = Constellations.all[constellationAbbreviation]
            if constellation != nil { // Bayer or Flamsteed Designation
                let flamsteedNumberString = String(value[flamsteedNumberRange]).trimmingCharacters(in: .whitespaces)
                if flamsteedNumberString.count > 0 {
                    let flamsteedNumber = Int(flamsteedNumberString)
                    if flamsteedNumber != nil{
                        flamsteed = FlamsteedDesignation(number: flamsteedNumber!, constellation: constellation!)
                    } else {
                        breakOut = true
                    }
                }
                let bayerLetter = String(value[bayerLetterRange]).trimmingCharacters(in: .whitespaces)
                if bayerLetter.count > 0 {
                    let bayerSuperScriptString = String(value[bayerSuperScriptRange]).trimmingCharacters(in: .whitespaces)
                    var bayerSuperScript: Int? = nil
                    if bayerSuperScriptString.count > 0 {
                        bayerSuperScript = Int(bayerSuperScriptString)!
                    }
                    bayer = BayerDesignation(bayerLetter, superScript: bayerSuperScript, constellation: constellation!)
                    if bayer == nil {
                        breakOut = true
                    }
                }
                return (name: nil, bayer: bayer, flamsteed: flamsteed, constellation: constellation)
            } else { // name
                breakOut = true
            }
            if breakOut {
                return (name:trimmed, bayer: nil, flamsteed: nil, constellation: nil)
            }
        }
        return nil
    }
    
    func parseVariableStar(value: String) -> VariableStarDesignation? {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        if trimmed.count > 5 {
            let constellationAbbreviationRange = trimmed.index(trimmed.endIndex, offsetBy: -3)..<trimmed.endIndex
            let constellationAbbreviation = String(trimmed[constellationAbbreviationRange])
            let constellation = Constellations.all[constellationAbbreviation]
            if constellation != nil {
                let identifierRange = trimmed.startIndex..<trimmed.index(trimmed.endIndex, offsetBy: -4)
                let identifier = String(trimmed[identifierRange]).trimmingCharacters(in: .whitespaces)
                if identifier == identifier.uppercased() && identifier.count > 0 && identifier.count <= 2 {
                    return VariableStarDesignation(identifier: identifier, constellation: constellation!)
                } else if identifier.starts(with: "V") {
                    let vrange = identifier.index(trimmed.startIndex, offsetBy: 1)..<identifier.endIndex
                    if Int(String(identifier[vrange])) != nil {
                        return VariableStarDesignation(identifier: identifier, constellation: constellation!)
                    }
                }
            }
        }
        return nil
    }
}

struct CatalogFile : Decodable {
    
    let name: String
    let defaultType: String
    let files: [CatalogTextFile]
}

struct CatalogTextFile : Decodable {
    
    let filename: String
    let fields: [CatalogTextFileField]
}

struct CatalogTextFileField : Decodable {
    let name: String
    let startIndex: Int
    let endIndex: Int
    let type: String
    let typeData: [String: String]?
    let equinox: String?
    let epoch: String?
    let subfields: [CatalogTextFileField]?
}
