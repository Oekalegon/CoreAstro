//
//  CelestialObject.swift
//  
//
//  Created by Don Willems on 20/11/2021.
//

import Foundation

/// This protocol defines the features of a generic celestial object.
///
/// A celestial object is defined as an object in celestial space, e.g. with celestial coordinates.
/// This protocol requires objects to have simple function to get the coordinates in the different
/// coordinate systems.
///
/// For an extended object, the coordinates will be those of the centre of the object.
public protocol CelestialObject {
    
    /// The primary name of the object.
    ///
    /// Objects are allowed to not have a name (e.g. for catalog objects that only have identifiers).
    var name: String? {get}
    
    /// The set of names (with optional language identifier) of this object.
    var names: [StringLiteral] {get}
    
    /// The names for this object in the specified language.
    /// - Parameters:
    ///   - language: The language identifier
    /// - Returns: The names
    func names(language: String?) -> [String]
    
    /// Calculates the ICRS equatorial coordinates for the object at the specified date.
    /// - Parameters:
    ///   - date: The date for which the coordinates are requested
    /// - Returns: The ICRS coordinates at the specified date
    func equatorialCoordinates(on date: Date) -> Coordinates
    
    /// Calculates the equatorial coordinates for the object at the specified date and defined in
    /// the equatorial coordinate system valid for the specified equinox and for a specific location.
    ///
    /// Currently the most common equinox is J2000.0.
    ///
    /// The location is the location of the observer, this
    /// can be a location at the centre of gravity of the Solar system (`.barycentric`), the centre of
    /// the Earth (`.geocentric`), or a specific location on Earth (`.topocentric(location:)`)
    /// defined by a geographic location.
    /// - Parameters:
    ///   - date: The date for which the coordinates are requested
    ///   - equinox: The equinox of the coordinate system in which the coordinates will be defined
    ///   - location: The location of the observer for who the coordinates are valid
    /// - Returns: The equatorial coordinates of the object
    func equatorialCoordinates(on date: Date, equinox: Date, from location: CoordinateSystemOrigin) -> Coordinates
    
    /// Calculates the galactic coordinates for the object at the specifed date for an observer at the
    /// specified location.
    ///
    /// The location is the location of the observer, this
    /// can be a location at the centre of gravity of the Solar system (`.barycentric`), the centre of
    /// the Earth (`.geocentric`), or a specific location on Earth (`.topocentric(location:)`)
    /// defined by a geographic location.
    /// - Parameters:
    ///   - date: The date for which the coordinates are requested
    ///   - location: The location of the observer for who the coordinates are valid
    /// - Returns: The galactic coordinates of the object
    func galacticCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates
    
    /// Calculates the ecliptical coordinates for the object at the specifed date for an observer at the
    /// specified location.
    ///
    /// The location is the location of the observer, this
    /// can be a location at the centre of gravity of the Solar system (`.barycentric`), the centre of
    /// the Earth (`.geocentric`), or a specific location on Earth (`.topocentric(location:)`)
    /// defined by a geographic location.
    /// - Parameters:
    ///   - date: The date for which the coordinates are requested
    ///   - location: The location of the observer for who the coordinates are valid
    /// - Returns: The ecliptic coordinates of the object
    func eclipticalCoordinates(on date: Date, from location: CoordinateSystemOrigin) -> Coordinates
    
    /// Calculates the horizontal coordinates for the object at the specifed date for an observer at the
    /// specified location.
    ///
    /// The location is the location of the observer, and is defined by the geographic location on Earth.
    /// - Parameters:
    ///   - date: The date for which the coordinates are requested
    ///   - location: The geographic location  of the observer for who the coordinates are valid
    /// - Returns: The ecliptic coordinates of the object
    func horizontalCoordinates(on date: Date, from location: GeographicalLocation) -> Coordinates
    
}

/// This protocol defines the properties of celestial objects that are taken from an astronomical catalogue.
///
/// It includes access to indentifiers that identify the object within a specific catalog.
///
/// Most celestial objects will be taken from catalogs, such as stars, galaxies, or minor planets.
/// Some Solar system objects such as the planets and the Sun will not be taken from catalogs.
public protocol CatalogObject: CelestialObject {
    
    /// The primary identifier of the object.
    var identifier: ObjectIdentifier {get}
    
    /// The set of identifiers of this object.
    var identifiers: [ObjectIdentifier] {get}
}