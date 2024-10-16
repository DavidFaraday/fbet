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
