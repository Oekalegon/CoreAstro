//
//  File.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import CoreMeasure
import Foundation

public struct GeographicalLocation : Equatable {
    
    public let name: String?
    
    /// The geographical longitude of the location (between 0° and 180° if on the western hemisphere, and
    /// between 180° and 360° on the eastern hemisphere).
    public let longitude: Longitude
    public let latitude: Latitude
    public let elevation: Elevation?
    
    public init(name: String?=nil, longitude : Longitude, latitude: Latitude, elevation: Elevation?) {
        self.longitude = longitude
        self.latitude = latitude
        self.elevation = elevation
        self.name = name
    }
    
    public var siderealTime : SiderealTime {
        get {
            return siderealTime(on: Date())
        }
    }
    
    public func siderealTime(on date: Date, positionType: PositionType = .apparentPosition) -> SiderealTime {
        return SiderealTime(on: date, at: self, positionType: positionType)
    }
}

public class Elevation: Quantity {
    
    public init(_ elevation: Double, error: Double?) {
        try! super.init(elevation, error: error, scale: .elevation)
    }
}

extension Scale {
    static let elevation = IntervalScale(unit: .metre)
}

