//
//  File.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import Foundation

public enum CoordinateSystemOrigin : Equatable {
    case barycentric
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
    
    /// Defines whether the longitude defined for spherical coordinates in this coordinate system increases
    /// anti-clockwise or clockwise as viewed from an observer at the origin with the North pole of the
    /// coordinate system (the Z-axis) pointing upwards.
    ///
    /// All celestial coordinate systems are ani-clockwise except the horizontal (azimuthal) coordinate
    /// system which increases clockwise (from North at 0° Azimuth, East 90°, South 180°, West 270° and
    /// back to North).
    public let antiClockwise: Bool
    
    public static let ICRS = CoordinateSystem(type: .ICRS, origin: .barycentric)
    public static let equatorialJ2000 = CoordinateSystem(type: .equatorial, equinox: .J2000, origin: .barycentric)
    public static let equatorialJ2050 = CoordinateSystem(type: .equatorial, equinox: .J2050, origin: .barycentric)
    public static let equatorialB1950 = CoordinateSystem(type: .equatorial, equinox: .B1950, origin: .barycentric)
    public static let galactic = CoordinateSystem(type: .galactic, origin: .barycentric)
    
    public static func equatorial(for equinox: Date, from origin: CoordinateSystemOrigin = .geocentric) -> CoordinateSystem {
        return CoordinateSystem(type: .equatorial, equinox: equinox, origin: origin, antiClockwise: false)
    }
    
    public static func ecliptical(at epoch: Date, from origin: CoordinateSystemOrigin = .geocentric) -> CoordinateSystem {
        return CoordinateSystem(type: .elliptical, epoch: epoch, origin: origin)
    }
    
    public static func horizontal(at epoch: Date, for location: GeographicalLocation) -> CoordinateSystem {
        return CoordinateSystem(type: .horizontal, epoch: epoch, origin: .topcentric(location: location), antiClockwise: false)
    }
    
    private init(type: CoordinateSystemType, equinox: Date? = nil, epoch: Date? = nil, origin: CoordinateSystemOrigin, antiClockwise: Bool = true) {
        self.type = type
        self.equinox = equinox
        self.epoch = epoch
        self.origin = origin
        self.antiClockwise = antiClockwise
    }
}
