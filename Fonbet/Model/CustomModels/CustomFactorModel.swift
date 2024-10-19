//
//  CustomFactorModel.swift
//  Fonbet
//
//  Created by David Kababyan on 14/10/2024.
//

import Foundation

class CustomFactorModel {
    let id: Int
    var factors: [Int: FactorModel]
    
    init(customFactor: CustomFactor) {
        self.id = customFactor.e
        self.factors = [:]
    }
    
    func resetColors() {
        for factor in factors.values where factor.change != .noChange {
            factors[factor.f] = factor.resetChange()
        }
    }
    
    func updateFactors(customFactor: CustomFactor) {
        
        for factor in customFactor.factors {

            let oldFactorModel = factors[factor.f]
            
            let change: FactorChange
            
            if let oldModel = oldFactorModel {
                
                if oldModel.v > factor.v {
                    change = .decrease
                } else if oldModel.v < factor.v {
                    change = .increase
                } else {
                    continue // No change
                }
                
            } else {
                change = .noChange // New factor (no previous value)
            }
            
            // Update or add the factor model
            factors[factor.f] = FactorModel(factor: factor, change: change)
        }
        
    }
}
