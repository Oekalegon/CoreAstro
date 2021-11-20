//
//  CatalogIdentifier.swift
//  
//
//  Created by Don Willems on 20/11/2021.
//

import Foundation

public struct ObjectIdentifier: CustomStringConvertible {
    
    public let identifier: String
    public let catalogIdentifier: String
    
    public var description: String {
        return "\(catalogIdentifier) \(identifier)"
    }
}
