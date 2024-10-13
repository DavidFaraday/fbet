//
//  ResponseData.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

struct LineData: Codable {
    let packetVersion: Int
    let fromVersion: Int
    let catalogTablesVersion: Int
    let catalogSpecialTablesVersion: Int
    let catalogEventViewVersion: Int
    let sportBasicMarketsVersion: Int
    let sportBasicFactorsVersion: Int
    let independentFactorsVersion: Int
    let factorsVersion: Int
    let comboFactorsVersion: Int
    let sportKindsVersion: Int
    let topCompetitionsVersion: Int
    let eventSmartFiltersVersion: Int
    let geoCategoriesVersion: Int
    let sportCategoriesVersion: Int
    let sports: [Sport]
    let events: [Event]
    let customFactors: [CustomFactor]

    enum CodingKeys: String, CodingKey {
        case packetVersion = "packetVersion"
        case fromVersion = "fromVersion"
        case catalogTablesVersion = "catalogTablesVersion"
        case catalogSpecialTablesVersion = "catalogSpecialTablesVersion"
        case catalogEventViewVersion = "catalogEventViewVersion"
        case sportBasicMarketsVersion = "sportBasicMarketsVersion"
        case sportBasicFactorsVersion = "sportBasicFactorsVersion"
        case independentFactorsVersion = "independentFactorsVersion"
        case factorsVersion = "factorsVersion"
        case comboFactorsVersion = "comboFactorsVersion"
        case sportKindsVersion = "sportKindsVersion"
        case topCompetitionsVersion = "topCompetitionsVersion"
        case eventSmartFiltersVersion = "eventSmartFiltersVersion"
        case geoCategoriesVersion = "geoCategoriesVersion"
        case sportCategoriesVersion = "sportCategoriesVersion"
        case sports = "sports"
        case events = "events"
        case customFactors = "customFactors"
    }
}


