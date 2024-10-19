//
//  FactorModel.swift
//  Fonbet
//
//  Created by David Kababyan on 16/10/2024.
//

import Foundation

struct FactorModel: Comparable, Hashable {
    let f: Int
    let v: Double
    let p: Int?
    let pt: String?
    let change: FactorChange
    
    init(factor: Factor, change: FactorChange = .noChange) {
        self.f = factor.f
        self.v = factor.v
        self.p = factor.p
        self.pt = factor.pt
        self.change = change
    }
    
    private init(factor: FactorModel) {
        self.f = factor.f
        self.v = factor.v
        self.p = factor.p
        self.pt = factor.pt
        self.change = .noChange
    }
    
    func resetChange() -> FactorModel {
        .init(factor: self)
    }
    
    static func < (lhs: FactorModel, rhs: FactorModel) -> Bool {
        lhs.f < rhs.f
    }
    
    static func == (lhs: FactorModel, rhs: FactorModel) -> Bool {
        lhs.f == rhs.f &&
        lhs.v == rhs.v &&
        lhs.p == rhs.p &&
        lhs.pt == rhs.pt &&
        lhs.change == rhs.change
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(f)
    }
}
