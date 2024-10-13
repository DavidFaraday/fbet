//
//  CustomFactor.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

struct CustomFactor: Codable {
    let e: Int
    let countAll: Int
    let factors: [Factor]

    enum CodingKeys: String, CodingKey {
        case e = "e"
        case countAll = "countAll"
        case factors = "factors"
    }
}
