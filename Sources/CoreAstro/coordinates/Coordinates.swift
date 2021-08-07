//
//  Coordinates.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import CoreMeasure

/// Represents the spherical coordinates of an object in the coordinate system defined for a set of
/// coordinates.
public struct SphericalCoordinates {
    
    /// The angle of longitude in a spherical coordinate system measured from the intersection between
    /// the equator and the prime meridian towards east if the coordinate system is anti-clockwise.
    public let longitude: Longitude
    
    /// The latitude angle in a spherical coordinate system measured from the equator towards the north
    /// pole.
    public let latitude: Latitude
    
    /// The radial distance of the object from the origin.
    public let distance: Distance? = nil
}

/// Represents the rectangular coordinates of an object in the coordinate system defined for a set of
/// coordinates.
///
/// The rectangular coordinates are specified using distances from a predefined origin along the three
/// principal axis in a three-dimensional space.
public struct RectangularCoordinates {
    
    /// The distance along the X-axis, which is the axis from the origin through the intersection between
    /// the equator and prime meridian in the equivalent spherical coordinate system.
    public let x: Distance
    
    /// The distance along the Y-axis, which is the axis from the origin through the intersection between
    /// the equator and 90° longitude (to the east of the prime meridian) in the equivalent spherical
    /// coordinate system.
    public let y: Distance
    
    /// The distance along the Z-axis, which is the axis from the origin through the north pole in the
    /// equivalent spherical coordinate system.
    public let z: Distance
    
    /// The distance to the object at these coordinates to the origin of the coordinate system.
    public var distance: Distance {
        get {
            let measure = try! sqrt(pow(x,2) + pow(y,2) + pow(z,2))
            return try! Distance(symbold: "d", measure.scalarValue, error: measure.error, unit: measure.unit)
        }
    }
}

public class Distance: Quantity {
    
    public init(symbold: String? = nil, _ distance: Double, error: Double? = nil, unit: Unit) throws {
        if unit.dimensions != Unit.metre.dimensions {
            throw UnitValidationError.differentDimensionality
        }
        try super.init(symbol: symbol, distance, error: error, unit: unit)
    }
}

/// Represents the right ascension of an object which is the longitude of an object along the celestial
/// equator and east of the intersection of the circle through the vernal equinox and the north and south
/// pole.
public class RightAscension: Longitude {
    
    /// Creates a new right ascension with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the right ascension.
    ///   - error: The error.
    ///   - unit: The unit of the right ascension (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "α", scalarValue, error: error, unit: unit)
    }
}

/// Represents the declination of an object which is the latitude of the object above the celestial
/// equator. It is positive if it is north of the celestial equator, and negative when south of the ecliptic.
public class Declination: Latitude {
    
    /// Creates a new declination with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the declination.
    ///   - error: The error.
    ///   - unit: The unit of the declination (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "δ", scalarValue, error: error, unit: unit)
    }
}

/// Represents the ecliptical longitude of an object which is the longitude of an object along the ecliptic
/// and east of the vernal equinox.
public class EclipticalLongitude: Longitude {
    
    /// Creates a new ecliptical longitude with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the longitude.
    ///   - error: The error.
    ///   - unit: The unit of the longitude (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "λ", scalarValue, error: error, unit: unit)
    }
}

/// Represents the ecliptic latitude of an object which is the latitude of the object above the ecliptic. It is
/// positive if it is north of the ecliptic.
public class EclipticalLatitude: Latitude {
    
    /// Creates a new ecliptical latitude with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the latitude.
    ///   - error: The error.
    ///   - unit: The unit of the latitude (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "β", scalarValue, error: error, unit: unit)
    }
}

/// Represents the galactic longitude of an object which is the longitude of an object along the galactic equator
/// and east of the centre of the Galaxy.
public class GalacticLongitude: Longitude {
    
    /// Creates a new galactic longitude with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the longitude.
    ///   - error: The error.
    ///   - unit: The unit of the galactic longitude (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "l", scalarValue, error: error, unit: unit)
    }
}

/// Represents the galactic latitude of an object which is the latitude of the object above the galactic
/// equator. It is positive if it is north of the galactic equator.
public class GalacticLatitude: Latitude {
    
    /// Creates a new galactic latitude with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the latitude.
    ///   - error: The error.
    ///   - unit: The unit of the latitude (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "b", scalarValue, error: error, unit: unit)
    }
}

/// Represents an azimuth (the longitude in the horizontal coordinate system) of an object along the horizon.
///
/// It is measured from North (0°), through East (90°), South (180°), and West (270°).
public class Azimuth: Longitude {
    
    /// Creates a new galactic longitude with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the longitude.
    ///   - error: The error.
    ///   - unit: The unit of the galactic longitude (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "A", scalarValue, error: error, unit: unit)
    }
}

/// Represents an altitude (the latitude in the horizontal coordinate system) of an object above (positive) or
/// below (negative) the horizon.
public class Altitude: Latitude {
    
    /// Creates a new altitude (horizontal latitude) with the specified value.
    /// - Parameters:
    ///   - scalarValue: The value for the altitude.
    ///   - error: The error.
    ///   - unit: The unit of the altitude (default is degrees).
    /// - Throws: A ``UnitValidationError`` when the dimensions of the value do not
    /// correspond to the dimensions of the quantity.
    public init(_ scalarValue: Double, error: Double? = nil, unit: Unit = Unit.degree) throws {
        try super.init(symbol: "h", scalarValue, error: error, unit: unit)
    }
}


public struct Coordinates: Equatable, CustomStringConvertible {
    
    // The Rectangular Coordinates of the Coordinates. NB If the distance to
    // the object is unknown, these coordinates will still be used but with
    // a distance of 1 m. When requesting the ``rectangularCoordinates``, nil
    // should be returned in that case.
    private var _rectangularCoordinates: RectangularCoordinates
    
    public let system: CoordinateSystem
    
    public var distanceIsKnown: Bool
    
    public var sphericalCoordinate: SphericalCoordinates {
        get {
            let distance : Distance? = try! _rectangularCoordinates.distance.convert(to: .metre)
            let latitude = asin(_rectangularCoordinates.z/distance)
            let longitude = try! atan(_rectangularCoordinates.y, _rectangularCoordinates.x)
            if !distanceIsKnown {
                distance = nil
            }
            switch system.type {
            case .ICRS:
                return try! SphericalCoordinates(longitude: RightAscension(longitude.scalarValue, error: longitude.error, unit: longitude.unit), latitude: Declination(latitude.scalarValue, error: latitude.error, unit: latitude.unit), distance: distance)
            case .equatorial:
                return try! SphericalCoordinates(longitude: RightAscension(longitude.scalarValue, error: longitude.error, unit: longitude.unit), latitude: Declination(latitude.scalarValue, error: latitude.error, unit: latitude.unit), distance: distance)
            case .elliptical:
                return try! SphericalCoordinates(longitude: EclipticalLongitude(longitude.scalarValue, error: longitude.error, unit: longitude.unit), latitude: EclipticalLatitude(latitude.scalarValue, error: latitude.error, unit: latitude.unit), distance: distance)
            case .galactic:
                return try! SphericalCoordinates(longitude: GalacticLongitude(longitude.scalarValue, error: longitude.error, unit: longitude.unit), latitude: GalacticLatitude(latitude.scalarValue, error: latitude.error, unit: latitude.unit), distance: distance)
            case .horizontal:
                return try! SphericalCoordinates(longitude: Azimuth(longitude.scalarValue, error: longitude.error, unit: longitude.unit), latitude: Altitude(latitude.scalarValue, error: latitude.error, unit: latitude.unit), distance: distance)
            }
        }
    }
    
    public var rectangularCoordinates: RectangularCoordinates? {
        get {
            if distanceIsKnown {
                return _rectangularCoordinates
            }
            // Distance is not known, so the rectangular coordinates are not
            // known.
            return nil
        }
    }
        
    public func convert(to: CoordinateSystem) -> Coordinates throws {
        
    }
    
    public static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return false
    }
    
    public var description: String {
        get {
            return ""
        }
    }
}
