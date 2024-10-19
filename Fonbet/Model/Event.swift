//
//  Event.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

struct Event: Codable, Identifiable, Comparable {
    let id: Int
    let sortOrder: String
    let level: Int
    let num: Int
    let sportId: Int
    let kind: Int
    let rootKind: Int
    let team1Id: Int
    let team2Id: Int
    let team1: String?
    let team2: String?
    let name: String
    let startTime: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sortOrder = "sortOrder"
        case level = "level"
        case num = "num"
        case sportId = "sportId"
        case kind = "kind"
        case rootKind = "rootKind"
        case team1Id = "team1Id"
        case team2Id = "team2Id"
        case team1 = "team1"
        case team2 = "team2"
        case name = "name"
        case startTime = "startTime"
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

}

