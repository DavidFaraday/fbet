//
//  FactorModel.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

//class CustomFactorModel {
//    let id: Int
//    var factors: [Int: FactorModel]
//    
//    init(customFactor: CustomFactor) {
//        self.id = customFactor.e
//        self.factors = [:]
//    }
//    
//    func resetColors() {
//        print("RESETTING COLORS FOR \(id)")
//        let allFactors = factors.values
//        
//        for factor in allFactors {
//            factors[factor.f] = factor.resetChange()
//        }
//        print("done reseting colors")
//    }
//    func updateFactors(customFactor: CustomFactor) {
//        print("CHANGING FACTOR FOR \(customFactor.e)")
//
//        for factor in customFactor.factors {
//
//            if let oldFactorModel = factors[factor.f] {
//                //updating old value
//                if oldFactorModel.v > factor.v {
//                    //decreased
//                    factors[factor.f] = FactorModel(factor: factor, change: .decrease)
//
//                } else if oldFactorModel.v < factor.v {
//                    //increased
//                    factors[factor.f] = FactorModel(factor: factor, change: .increase)
//                }
//                
//                print(".....was \(oldFactorModel.v) now \(factor.v)")
//            } else {
//                print("set new value")
//                factors[factor.f] = FactorModel(factor: factor)
//            }
//        }
//    }
//}
