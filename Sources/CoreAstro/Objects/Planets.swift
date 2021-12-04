//
//  Planets.swift
//  
//
//  Created by Don Willems on 21/11/2021.
//

import Foundation

public class Planet : VSOPObject {
    
    public static let mercury = Planet(name: "Mercury")
    public static let venus = Planet(name: "Venus")
    public static let earth = Planet(name: "Earth")
    public static let mars = Planet(name: "Mars")
    public static let jupiter = Planet(name: "Jupiter")
    public static let saturn = Planet(name: "Saturn")
    public static let uranus = Planet(name: "Uranus")
    public static let neptune = Planet(name: "Neptune")
    
    public override var types: [CelestialObjectType] {
        get {
            return [.solarSystemObject, .planet]
        }
    }
    
}
