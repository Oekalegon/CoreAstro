//
//  SolarSystemObject.swift
//  
//
//  Created by Don Willems on 21/11/2021.
//

import Foundation
import CoreMeasure

/// Object that adhere to this protocol represent objects in the Solar System
public protocol SolarSystemObject : CelestialObject {
    
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
        let T = date.julianCenturiesSinceJ2000.scalarValue/10.0 // Julian Millenia
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
        print(">>>> \(rectComponents)")
        let coord = Coordinates(rectangularCoordinates: rectComponents, system: .equatorial(for: .J2000, from: .barycentric), positionType: .meanPosition)
        print(">>>> \(coord)")
        print("Distance: \(try! coord.sphericalCoordinates.distance!.convert(to: .astronomicalUnit))")
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
    }
}
