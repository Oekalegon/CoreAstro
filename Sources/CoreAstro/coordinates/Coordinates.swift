//
//  Coordinates.swift
//  
//
//  Created by Don Willems on 19/07/2021.
//

import CoreMeasure
import Security

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
    public let distance: Distance?
    
    
    /// Create a new set of Spherical coordinates.
    /// - Parameters:
    ///   - longitude: The longitude of the coordinates.
    ///   - latitude: The latitudes of the coordinates.
    ///   - distance: The distance of the coordinates.
    public init(longitude: Longitude, latitude: Latitude, distance: Distance? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.distance = distance
    }
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
            return try! Distance(symbol: "d", measure.scalarValue, error: measure.error, unit: measure.unit)
        }
    }
}

public class Distance: Quantity {
    
    /// Creates a copy of the ``Measure`` in a specific `Distance`.
    /// - Parameters:
    ///   - symbol: An optional symbol used for the quantity.
    ///   - measure: The measure to be copied in the quanity.
    public override init(symbol: String? = nil, measure: Measure) throws {
        if measure.unit.dimensions != Unit.metre.dimensions {
            throw UnitValidationError.differentDimensionality
        }
        try super.init(symbol: symbol, measure: measure)
    }
    
    public override init(symbol: String? = nil, _ distance: Double, error: Double? = nil, unit: Unit) throws {
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

/// The type of position of an object depending on which corrections are applied to the coordinates.
public enum PositionType {
    
    /// The mean position of an object, i.e. the position of the object as seen from the barycentre of the
    /// solar system, corrected for proper motion (in case of a star), but not for nutation.
    case meanPosition
    
    /// The true position of an object, i.e. the position of the object as seen from the barycentre of the
    /// solar system, corrected for proper motion (in case of a star), and also for nutation
    case truePosition
    
    /// The apparent position of an object, i.e. the position of the object as seen from either a geocentric
    /// observer or an observer on the surface of the Earth (a topocentric observer).
    ///
    /// The position is corrected for proper motion (in case of a star), and also for nutation and abberation.
    /// It should also include the effect of parallax.
    case apparentPosition
}


public struct Coordinates: Equatable, CustomStringConvertible {
    
    /// The equatorial coodinates of the galactic pole in B1950.0.
    private static let galacticNorthPole = SphericalCoordinates(longitude: try! Longitude(192.25, unit: .degree), latitude: try! Latitude(27.4, unit: .degree))
    
    // The Rectangular Coordinates of the Coordinates. NB If the distance to
    // the object is unknown, these coordinates will still be used but with
    // a distance of 1 m. When requesting the ``rectangularCoordinates``, nil
    // should be returned in that case.
    private var _rectangularCoordinates: RectangularCoordinates
    
    /// The coordinate system in which the coordinates are defined.
    public let system: CoordinateSystem
    
    /// The type of coordinates, either *mean*, *true*, or *apparent*, depending on which gravitational
    /// effects are taken into account.
    public let positionType: PositionType
    
    /// A flag to denote whether the distance is known.
    public var distanceIsKnown: Bool
    
    /// The spherical coordinates (longitude, latitude, and optionally distance) of the coordinates on the
    /// celestial sphere.
    public var sphericalCoordinates: SphericalCoordinates {
        get {
            var distance : Distance? = try! Distance(measure: try! _rectangularCoordinates.distance.convert(to: .metre))
            let latitude = asin(_rectangularCoordinates.z/distance!)
            var longitude = try! atan(_rectangularCoordinates.y, _rectangularCoordinates.x)
            if !self.system.antiClockwise {
                longitude = try! -longitude
            }
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
    
    
    /// The coordinates expressed as rectangular coordinates with an X, Y, and Z component.
    ///
    /// If the distance to an object is not known, `nil` will be returned. Many objects will only be
    /// defined using spherical coordinates on the celestial sphere without a known distance.
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
    
    /// Creates a new set of coordinates specified by the given rectangular coordinates defined in the
    /// specified coordinate system.
    /// - Parameters:
    ///   - rectangularCoordinates: The rectangular coordinates.
    ///   - system: The coordinate system in which these coordinates are defined.
    ///   - positionType: The type of position, either the *mean*, *true*, or *apparent* position.
    public init(rectangularCoordinates: RectangularCoordinates, system: CoordinateSystem, positionType: PositionType) {
        self._rectangularCoordinates = rectangularCoordinates
        self.system = system
        self.positionType = positionType
        self.distanceIsKnown = true
    }
    
    /// Creates a new set of coordinates specified by the given spherical coordinates on the celestial
    /// sphere, and defined in the specified coordinate system.
    /// - Parameters:
    ///   - sphericalCoordinates: The spherical coordinates.
    ///   - system: The coordinate system in which these coordinates are defined.
    ///   - positionType: The type of position, either the *mean*, *true*, or *apparent* position.
    public init(sphericalCoordinates: SphericalCoordinates, system: CoordinateSystem, positionType: PositionType) {
        let distance = sphericalCoordinates.distance != nil ? sphericalCoordinates.distance : try! Distance(1.0, unit: .metre)
        let r = cos(sphericalCoordinates.latitude) * distance!
        var longitude = sphericalCoordinates.longitude
        if !system.antiClockwise {
            longitude = try! -longitude
        }
        self._rectangularCoordinates = RectangularCoordinates(
            x: try! Distance(measure: cos(longitude) * r),
            y: try! Distance(measure: sin(longitude) * r),
            z: try! Distance(measure: sin(sphericalCoordinates.latitude) * distance!)
        )
        self.system = system
        self.positionType = positionType
        self.distanceIsKnown = sphericalCoordinates.distance != nil ? true : false
    }
        
    public func convert(to target: CoordinateSystem, positionType: PositionType) throws -> Coordinates {
        // TODO: Take the type of position into account
        if self.system == target && self.positionType == positionType {
            return self
        }
        if self.system.type == .equatorial && self.system.equinox == .J2000 {
            if target.type == .elliptical {
                let ε = try meanObliquityOfTheEcliptic(on: target.epoch!)
                let np = SphericalCoordinates(longitude: try Longitude(270.0, unit: .degree), latitude: try Latitude(90.0-ε.scalarValue, unit: .degree))
                let rc = Coordinates.convertFromEquatorial(systemNorthPole: np, ascendingNode: try Longitude(0, unit: .degree), coordinates: self._rectangularCoordinates)
                let newcoord = Coordinates(rectangularCoordinates: rc, system: target, positionType: positionType)
                return newcoord
            } else if target.type == .galactic {
                let np = SphericalCoordinates(longitude: try Longitude(192.85948402, unit: .degree), latitude: try Latitude(27.12829637, unit: .degree))
                let rc = Coordinates.convertFromEquatorial(systemNorthPole: np, ascendingNode: try Longitude(249.9276045998651, unit: .degree), coordinates: self._rectangularCoordinates)
                let newcoord = Coordinates(rectangularCoordinates: rc, system: target, positionType: positionType)
                return newcoord
            } else if target.type == .horizontal {
                if target.epoch == nil {
                    throw CoreAstroError.epochNotDefined
                }
                var geographicalLocation: GeographicalLocation? = nil
                switch target.origin {
                case .topocentric(let location):
                    geographicalLocation = location
                default:
                    throw CoreAstroError.topographicLocationNotDefined
                }
                let ϕ = try! Latitude(measure: geographicalLocation!.latitude.convert(to: .degree))
                let θ = try SiderealTime(on: target.epoch!, at: geographicalLocation!, positionType: positionType)
                let ω = try Longitude(θ.convert(to: .degree).scalarValue + 180, unit: .degree)
                let np = SphericalCoordinates(longitude: Longitude(angle: θ), latitude: ϕ)
                let rc = Coordinates.convertFromEquatorial(systemNorthPole: np, ascendingNode: ω, coordinates: self._rectangularCoordinates)
                let newcoord = Coordinates(rectangularCoordinates: rc, system: target, positionType: positionType)
                return newcoord
            }
        } else if target.type == .equatorial && target.equinox == .J2000 {
            if self.system.type == .elliptical {
                let ε = try meanObliquityOfTheEcliptic(on: self.system.epoch!)
                let np = SphericalCoordinates(longitude: try Longitude(270.0, unit: .degree), latitude: try Latitude(90.0-ε.scalarValue, unit: .degree))
                let rc = Coordinates.convertToEquatorial(systemNorthPole: np, ascendingNode: try Longitude(0, unit: .degree), coordinates: self._rectangularCoordinates)
                let newcoord = Coordinates(rectangularCoordinates: rc, system: target, positionType: positionType)
                return newcoord
            } else if self.system.type == .galactic {
                let np = SphericalCoordinates(longitude: try Longitude(192.85948402, unit: .degree), latitude: try Latitude(27.12829637, unit: .degree))
                let rc = Coordinates.convertToEquatorial(systemNorthPole: np, ascendingNode: try Longitude(249.9276045998651, unit: .degree), coordinates: self._rectangularCoordinates)
                let newcoord = Coordinates(rectangularCoordinates: rc, system: target, positionType: positionType)
                return newcoord
            } else if self.system.type == .horizontal {
                if self.system.epoch == nil {
                    throw CoreAstroError.epochNotDefined
                }
                var geographicalLocation: GeographicalLocation? = nil
                switch self.system.origin {
                case .topocentric(let location):
                    geographicalLocation = location
                default:
                    throw CoreAstroError.topographicLocationNotDefined
                }
                let ϕ = try! Latitude(measure: geographicalLocation!.latitude.convert(to: .degree))
                let θ = try SiderealTime(on: self.system.epoch!, at: geographicalLocation!, positionType: positionType)
                let ω = try Longitude(θ.convert(to: .degree).scalarValue + 180, unit: .degree)
                let np = SphericalCoordinates(longitude: Longitude(angle: θ), latitude: ϕ)
                let rc = Coordinates.convertToEquatorial(systemNorthPole: np, ascendingNode: ω, coordinates: self._rectangularCoordinates)
                let newcoord = Coordinates(rectangularCoordinates: rc, system: target, positionType: positionType)
                return newcoord
            }
        } else {
            let intermediate = try self.convert(to: .equatorialJ2000, positionType: positionType)
            return try intermediate.convert(to: target, positionType: positionType)
        }
        throw CoreAstroError.notImplemented
    }
    
    private static func convertFromEquatorial(systemNorthPole np: SphericalCoordinates, ascendingNode ω: Longitude, coordinates: RectangularCoordinates) -> RectangularCoordinates {
        let γ = try! -np.longitude
        let β = try! Angle(measure: try! Angle(90, unit: .degree) - np.latitude)
        let γ2 = try! Angle(measure: -γ - ω)
        let rect1 = Coordinates.rotate(aroundZ: γ, coordinates: coordinates)
        let rect2 = Coordinates.rotate(aroundY: try! -β, coordinates: rect1)
        let rect3 = Coordinates.rotate(aroundZ: γ2, coordinates: rect2)
        return rect3
    }
    
    private static func convertToEquatorial(systemNorthPole np: SphericalCoordinates, ascendingNode ω: Longitude, coordinates: RectangularCoordinates) -> RectangularCoordinates {
        let γ = np.longitude
        let β = try! Angle(measure: try! Angle(90, unit: .degree) - np.latitude)
        let γ2 = try! Angle(measure: γ - ω)
        let rect1 = Coordinates.rotate(aroundZ: try! -γ2, coordinates: coordinates)
        let rect2 = Coordinates.rotate(aroundY: β, coordinates: rect1)
        let rect3 = Coordinates.rotate(aroundZ: γ, coordinates: rect2)
        return rect3
    }
    
    private static func rotate(aroundY β: Angle, coordinates: RectangularCoordinates) -> RectangularCoordinates {
        let cos_β = cos(β).scalarValue
        let sin_β = sin(β).scalarValue
        let x = try! coordinates.x * cos_β + coordinates.z * sin_β
        let y = coordinates.y
        let z = try! coordinates.x * -sin_β + coordinates.z * cos_β
        return RectangularCoordinates(x: try! Distance(measure:x), y: try! Distance(measure:y), z: try! Distance(measure:z))
    }
    
    private static func rotate(aroundZ γ: Angle, coordinates: RectangularCoordinates) -> RectangularCoordinates {
        let cos_γ = cos(γ).scalarValue
        let sin_γ = sin(γ).scalarValue
        let x = try!coordinates.x * cos_γ - coordinates.y * sin_γ
        let y = try! coordinates.x * sin_γ + coordinates.y * cos_γ
        let z = coordinates.z
        return RectangularCoordinates(x: try! Distance(measure:x), y: try! Distance(measure:y), z: try! Distance(measure:z))
    }
    
    /// Calculates the angular separation between this set of coordinates to another set of coordinates.
    /// - Parameter coordinates: The coordinates to which the angular separation should be calculated
    /// - Returns: The angular separation
    public func angularSeparation(to coordinates: Coordinates) throws -> Angle {
        let converted = try coordinates.convert(to: self.system, positionType: self.positionType)
        let dlat = try converted.sphericalCoordinates.latitude - self.sphericalCoordinates.latitude
        let dlon = try converted.sphericalCoordinates.longitude - self.sphericalCoordinates.longitude
        let havd = try hav(try Angle(measure:dlat)) + cos(self.sphericalCoordinates.latitude) * cos(coordinates.sphericalCoordinates.latitude) * hav(try Angle(measure:dlon))
        let d = ahav(havd)
        return d
    }
    
    /// Calculates the angular separation between two sets of coordinates.
    /// - Parameters:
    ///   - coordinates1: The first set of coordinates
    ///   - coordinates2: The second set of coordiantes
    /// - Returns: The angular separation
    public static func angularSeparation(between coordinates1: Coordinates, and coordinates2: Coordinates) throws -> Angle {
        return try coordinates1.angularSeparation(to: coordinates2)
    }
    
    /// Calculates the relative position angle to the specified set of coordinates.
    ///
    /// The origin of the position angle is North (0°). If the set of coordinates are due east of this set of coordinates,
    /// the position angle will be 90°, due south 180°, and west 270°.
    /// - Parameter coordinates: The coordinates to which the position angle should be calculated
    /// - Returns: The relative position angle from North, towards East.
    public func relativePositionAngle(to coordinates: Coordinates) throws -> NormalisedAngle {
        let converted = try coordinates.convert(to: self.system, positionType: self.positionType)
        let dlon = try Angle(measure: try converted.sphericalCoordinates.longitude - self.sphericalCoordinates.longitude)
        let angle = try atan(sin(dlon), cos(self.sphericalCoordinates.latitude)*tan(coordinates.sphericalCoordinates.latitude) - sin(self.sphericalCoordinates.latitude)*cos(dlon))
        return NormalisedAngle(angle: angle)
    }
    
    /// Calculates the relative position angle from the first set of coordinates to the second set of coordinates.
    ///
    /// The origin of the position angle is North (0°). If the second set of coordinates are due east to the first set of coordinates,
    /// the position angle will be 90°, due south 180°, and west 270°.
    /// - Parameters:
    ///   - coodinates1: The set of coordinates from which the position angle should be calculated
    ///   - coordinates2: The set of coordinates to which the position angle should be calculated
    /// - Returns: The relative position angle from North, towards East.
    public static func relativePositionAngle(from coodinates1: Coordinates, to coordinates2: Coordinates) throws -> NormalisedAngle {
        return try coodinates1.relativePositionAngle(to: coordinates2)
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
