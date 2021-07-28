//
//  File.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import Foundation

public enum CoordinateSystemOrigin : Equatable {
    case barycentric
    case heliocentric
    case geocentric
    case topcentric(location: GeographicalLocation)
}

public enum CoordinateSystemType : Equatable {
    case ICRS
    case equatorial
    case elliptical
    case horizontal
    case galactic
}

public struct CoordinateSystem: Equatable {
    
    public let type: CoordinateSystemType
    public let equinox: Date?
    public let epoch: Date?
    public let origin: CoordinateSystemOrigin
    
    public static let ICRS = CoordinateSystem(type: .ICRS, origin: .barycentric)
    public static let equatorialJ2000 = CoordinateSystem(type: .equatorial, equinox: .J2000, origin: .barycentric)
    public static let equatorialJ2050 = CoordinateSystem(type: .equatorial, equinox: .J2050, origin: .barycentric)
    public static let equatorialB1950 = CoordinateSystem(type: .equatorial, equinox: .B1950, origin: .barycentric)
    public static let galactic = CoordinateSystem(type: .galactic, origin: .barycentric)
    
    public static func ecliptical(at epoch: Date, from origin: CoordinateSystemOrigin = .geocentric) -> CoordinateSystem {
        return CoordinateSystem(type: .elliptical, epoch: epoch, origin: origin)
    }
    
    public static func horizontal(at epoch: Date, for location: GeographicalLocation) -> CoordinateSystem {
        return CoordinateSystem(type: .horizontal, epoch: epoch, origin: .topcentric(location: location))
    }
    
    private init(type: CoordinateSystemType, equinox: Date? = nil, epoch: Date? = nil, origin: CoordinateSystemOrigin) {
        self.type = type
        self.equinox = equinox
        self.epoch = epoch
        self.origin = origin
    }
}
