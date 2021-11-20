//
//  File.swift
//  
//
//  Created by Don Willems on 13/08/2021.
//

import Foundation


/// Generic errors in CoreAstro.
public enum CoreAstroError: Error {
    
    /// Thrown when the requested method is defined but not yet implemented.
    ///
    /// This may also happen when a method is not implemented for specific conditions (e.g. arguments
    /// to a function).
    case notImplemented
    
    /// Thrown when the epoch was not defined.
    case epochNotDefined
    
    /// Thrown when the equinox was not defined.
    case equinoxNotDefined
    
    /// Thrown when the topographic location of the observer was not defined.
    case geographicLocationNotDefined
    
    /// Thrown when the coordinates are not in the expected coordinate system.
    case incorrectCoordinateSystem
}
