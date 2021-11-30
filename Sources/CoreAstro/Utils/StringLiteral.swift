//
//  File.swift
//  
//
//  Created by Don Willems on 20/11/2021.
//

import Foundation

public struct StringLiteral {
    
    public let string: String
    public let language: String?
    
    public init(_ string: String, language: String? = nil) {
        self.string = string
        self.language = language
    }
}
