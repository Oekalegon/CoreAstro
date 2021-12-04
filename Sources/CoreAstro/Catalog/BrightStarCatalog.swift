//
//  File.swift
//  
//
//  Created by Don Willems on 30/11/2021.
//

import Foundation
import CoreMeasure

public struct BrightStarCatalog: Catalog {
    
    public var name: String {
        get {
            return "Bright Star Catalogue"
        }
    }
    
    public var abbreviation: String {
        get {
            return "BSC"
        }
    }
    
    public static let catalog = try! BrightStarCatalog()
    
    private var objects = [CatalogObject]()
    
    /// The number of objects in the catalog
    public var count: Int {
        get {
            return objects.count
        }
    }
    
    /// The catalog object at the specified integer index.
    /// - Parameter index: The integer index.
    /// - Returns: The object at the specified index, or `nil` when the index is outside of
    /// the range.
    public subscript(index: Int) -> CatalogObject? {
        if index<0 || index >= self.count {
            return nil
        }
        return objects[index]
    }
    
    /// The types of the celestial object contained in the catalog.
    public var types = [CelestialObjectType]()
    
    private init() throws {
        try PersistenceController.shared.createCatalog(catalog: self)
        self.load(from: Bundle.module.url(forResource: "BSC", withExtension: "json")!)
    }
    
    private func load(from url: URL) {
        let coredataControl = PersistenceController.shared
        let fileReader = CatalogTextFileReader(url: url)
        let objects = fileReader.load()
    }
}
