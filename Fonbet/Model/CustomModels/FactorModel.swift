//
//  FactorModel.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

class FactorModel {
    let id: Int
    var factors: [Int: Factor]
    
    init(customFactor: CustomFactor) {
        self.id = customFactor.e
        self.factors = [:]
    }
    
    func updateFactors(customFactor: CustomFactor) {
        
        for factor in customFactor.factors {
            factors[factor.f] = factor
        }
    }
}
