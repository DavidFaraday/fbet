//
//  Factor.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

struct Factor: Codable, Comparable, Hashable {
    let f: Int
    let v: Double
    let p: Int?
    let pt: String?

    static func < (lhs: Factor, rhs: Factor) -> Bool {
        lhs.f < rhs.f
    }

    enum CodingKeys: String, CodingKey {
        case f = "f"
        case v = "v"
        case p = "p"
        case pt = "pt"
    }
}



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
}

