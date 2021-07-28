//
//  File.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import CoreMeasure

public struct GeographicalLocation : Equatable {
    
    public let name: String?
    public let longitude: Longitude
    public let latitude: Latitude
    public let elevation: Elevation?
    
    public init(name: String?=nil, longitude : Longitude, latitude: Latitude, elevation: Elevation?) {
        self.longitude = longitude
        self.latitude = latitude
        self.elevation = elevation
        self.name = name
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

