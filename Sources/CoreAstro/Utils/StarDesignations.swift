//
//  File.swift
//  
//
//  Created by Don Willems on 30/11/2021.
//

import Foundation

/// This structure represents a Bayer designation used for the identification of stars as assigned by the
/// German astronomer Johann Bayer. It usually contains a Greek (or Latin) letter followed by the
/// genetive form of its parent constellation. It may also contain a superscript number, usually used
/// for the components of optical double stars.
public struct BayerDesignation : CustomStringConvertible {
    
    private static let letters = [
        "α": "alpha",
        "β": "beta",
        "γ": "gamma",
        "δ": "delta",
        "ε": "epsilon",
        "ζ": "zeta",
        "η": "eta",
        "θ": "theta",
        "ι": "iota",
        "κ": "kappa",
        "λ": "lambda",
        "μ": "mu",
        "ν": "nu",
        "ξ": "xi",
        "ο": "omicron",
        "π": "pi",
        "ρ": "rho",
        "σ": "sigma",
        "τ": "tau",
        "υ": "upsilon",
        "φ": "phi",
        "χ": "chi",
        "ψ": "psi",
        "ω": "omega"
    ]
    
    /// The letter used to identify the star in the constellation.
    public let letter: String
    
    /// The superscript number of the star, usually used to identify the component of an optical double star.
    public let superScript: Int?
    
    /// The parent constellation of the star.
    public let constellation: Constellation
    
    /// The abbreviated form of the Bayer designation, using the abbreviated name of the constellation,
    /// e.g. β Ori.
    public var abbreviated: String {
        get {
            let superscriptString = superScript != nil ? "\(superScript!)" : ""
            return "\(letter)\(superscriptString) \(constellation.abbreviation!)"
        }
    }
    
    /// The transcribed form of the Bayer designation, using the genitive form of the constellation,
    /// e.g. beta Orionis.
    public var transcibed: String {
        get {
            let superscriptString = superScript != nil ? "\(superScript!)" : ""
            var transcription = BayerDesignation.letters[self.letter]
            if transcription == nil {
                transcription = self.letter
            }
            return "\(transcription!)\(superscriptString) \(constellation.genitive)"
        }
    }
    
    /// The  Bayer designation, using the genitive form of the constellation,
    /// e.g. β Orionis.
    public var designation: String {
        get {
            let superscriptString = superScript != nil ? "\(superScript!)" : ""
            return "\(letter)\(superscriptString) \(constellation.genitive)"
        }
    }
    
    public var description: String {
        get {
            return designation
        }
    }
    
    init?(_ string: String, superScript: Int? = nil, constellation: Constellation) {
        if string.count == 0 {
            return nil
        }
        var greekLetter: String? = nil
        if string.count == 1 {
            greekLetter = string
        } else {
            let lc = string.lowercased()
            for greek in BayerDesignation.letters.keys {
                if BayerDesignation.letters[greek]!.starts(with: lc) {
                    greekLetter = greek
                    break
                }
            }
        }
        if greekLetter == nil {
            greekLetter = string
        }
        self.letter = greekLetter!
        self.superScript = superScript
        self.constellation = constellation
    }
}


/// This structure represents a Flamsteed designation used for the identification of stars as assigned by the
/// British astronomer John Flamsteed. It a contains number followed by the
/// genetive form of its parent constellation.
public struct FlamsteedDesignation : CustomStringConvertible {
    
    /// The flamsteed number of the star.
    public let number: Int
    
    /// The parent constellation.
    public let constellation: Constellation
    
    /// The abbreviated form of the Flamsteed designation, using the abbreviated name of the constellation,
    /// e.g. 12 Leo.
    public var abbreviated: String {
        get {
            return "\(number) \(constellation.abbreviation!)"
        }
    }
    
    /// The  Flamsteed designation, using the genitive form of the constellation,
    /// e.g. 12 Leonis.
    public var designation: String {
        get {
            return "\(number) \(constellation.genitive)"
        }
    }
    
    public var description: String {
        get {
            return designation
        }
    }
}

/// This structure represents a Variable star designation. It contains either one or two letters (starting at R) or
/// a 'V' followed by a number and the genetive form of its parent constellation.
public struct VariableStarDesignation : CustomStringConvertible {
    
    /// The variable star identifier, e.g. R, or V354
    public let identifier: String
    
    /// The parent constellation.
    public let constellation: Constellation
    
    /// The abbreviated form of the variable star  designation, using the abbreviated name of the constellation,
    /// e.g. R And.
    public var abbreviated: String {
        get {
            return "\(identifier) \(constellation.abbreviation!)"
        }
    }
    
    /// The  variable star  designation, using the genitive form of the constellation,
    /// e.g. R Andromedae.
    public var designation: String {
        get {
            return "\(identifier) \(constellation.genitive)"
        }
    }
    
    public var description: String {
        get {
            return designation
        }
    }
}
