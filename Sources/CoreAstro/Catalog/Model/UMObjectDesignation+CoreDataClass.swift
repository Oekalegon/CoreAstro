//
//  UMObjectDesignation+CoreDataClass.swift
//  
//
//  Created by Don Willems on 05/12/2021.
//
//

import Foundation
import CoreData


public class UMObjectDesignation: NSManagedObject {

    public var bayerDesignation: BayerDesignation? {
        get {
            if self.bayer != nil {
                let letter = self.bayer!
                var superscript : Int? = Int(self.bayerSuperScript)
                if superscript != nil && superscript! <= 0 {
                    superscript = nil
                }
                let constel = self.constellationAbbreviation!
                let constellation = Constellations.all[constel]
                if constellation == nil {
                    return nil
                }
                return BayerDesignation(letter, superScript: superscript, constellation: constellation!)
            }
            return nil
        }
    }
    
    public var flamsteedDesignation: FlamsteedDesignation? {
        get {
            if self.flamsteed > 0 {
                let number = Int(exactly: self.flamsteed)!
                let constel = self.constellationAbbreviation!
                let constellation = Constellations.all[constel]
                if constellation == nil {
                    return nil
                }
                return FlamsteedDesignation(number: number, constellation: constellation!)
            }
            return nil
        }
    }
    
    public var variableStarDesignation: VariableStarDesignation? {
        get {
            if self.variableStar != nil {
                let vsdeg = self.variableStar!
                let constel = self.constellationAbbreviation!
                let constellation = Constellations.all[constel]
                if constellation == nil {
                    return nil
                }
                return VariableStarDesignation(identifier: vsdeg, constellation: constellation!)
            }
            return nil
        }
    }
}
