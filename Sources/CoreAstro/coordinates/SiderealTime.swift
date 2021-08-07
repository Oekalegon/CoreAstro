//
//  SiderealTime.swift
//  
//
//  Created by Don Willems on 07/08/2021.
//

import CoreMeasure
import Foundation

public class SiderealTime: NormalisedAngle {
    
    public let positionType: PositionType
    
    public init(_ scalarValue: Double, error: Double? = nil, unit: CoreMeasure.Unit, positionType: PositionType = .meanPosition) throws {
        self.positionType = positionType
        try super.init(symbol: "θ", scalarValue, error: error, unit: unit, range: (min: Measure(0, unit: .degree), max: Measure(360, unit: .degree)))
    }
    
    public convenience init(at location: GeographicalLocation, positionType: PositionType = .meanPosition) {
        self.init(on: Date(), at: location, positionType: positionType)
    }
    
    public init(on date: Date, at location: GeographicalLocation, positionType: PositionType = .meanPosition) {
        let JD = date.julianDay.scalarValue
        let T = (JD - 2451545.0)/36525
        let θ_0 = try! Measure(280.46061837 + 360.98564736629 * (JD - 2451545.0) + 0.000387933 * T * T - T * T * T / 38710000, error: 0.00000001, unit: .degree)
        let θ = try! θ_0 - location.longitude
        if positionType != .meanPosition {
            // TODO: Apply Nutation for true or apparent sidereal time
        }
        self.positionType = positionType
        try! super.init(symbol: "θ", θ.scalarValue, error: θ.error, unit: θ.unit, range: (min: Measure(0, unit: .degree), max: Measure(360, unit: .degree)))
    }
}
