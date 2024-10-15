//
//  CustomFactor.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

struct CustomFactor: Codable, Hashable {
    let e: Int
    let countAll: Int
    var factors: [Factor]

    enum CodingKeys: String, CodingKey {
        case e = "e"
        case countAll = "countAll"
        case factors = "factors"
    }
}
