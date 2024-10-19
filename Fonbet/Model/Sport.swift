//
//  Sport.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

struct Sport: Codable, Identifiable, Equatable, Comparable, Hashable {
    let id: Int
    let sortOrder: String
    let parentId: Int?
    let kind: String
    let name: String
    
    static func ==(lhs: Sport, rhs: Sport) -> Bool {
        lhs.id == rhs.id
    }
    
    static func < (lhs: Sport, rhs: Sport) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sortOrder = "sortOrder"
        case parentId = "parentId"
        case kind = "kind"
        case name = "name"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

