//
//  File.swift
//  
//
//  Created by Don Willems on 30/11/2021.
//

import Foundation
import CoreMeasure

public struct BrightStarCatalog: Catalog {
    
    public static let catalog = BrightStarCatalog()
    
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
    
    private init() {
        self.load(from: Bundle.module.url(forResource: "BSC", withExtension: "json")!)
    }
    
    private func load(from url: URL) {
        let fileReader = CatalogTextFileReader(url: url)
        fileReader.load()
    }
}
