//
//  SportsModel.swift
//  Fonbet
//
//  Created by David Kababyan on 14/10/2024.
//

import Foundation

struct SportModel: Identifiable, Comparable {
    
    let id: Int
    let parentId: Int?
    let sortOrder: String
    let name: String
    
    let events: [EventModel]
    
    init(sport: Sport) {
        self.id = sport.id
        self.parentId = sport.parentId
        self.sortOrder = sport.sortOrder
        self.name = sport.name
        self.events = []
    }
    
    private init(sportModel: SportModel, events: [EventModel]) {
        self.id = sportModel.id
        self.parentId = sportModel.parentId
        self.sortOrder = sportModel.sortOrder
        self.name = sportModel.name
        self.events = events
    }
    
    func setEventsDictionary(events: [EventModel]) -> SportModel {
        .init(sportModel: self, events: events)
    }
    
    static func < (lhs: SportModel, rhs: SportModel) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
    
    static func == (lhs: SportModel, rhs: SportModel) -> Bool {
        lhs.id == rhs.id
    }
}

struct EventModel: Identifiable {
    let id: Int
    let sortOrder: String
    let level: Int
    let sportId: Int
    let team1: String?
    let team2: String?
    let startTime: Date

    let factorDictionary: [Int: CustomFactorModel] = [:]
    
    init(event: Event) {
        self.id = event.id
        self.sortOrder = event.sortOrder
        self.level = event.level
        self.sportId = event.sportID
        self.team1 = event.team1
        self.team2 = event.team2
        self.startTime = Date(timeIntervalSince1970: TimeInterval(event.startTime))
    }
}


class CustomFactorModel {
    let id: Int
    var factors: [Int: FactorModel]
    
    init(customFactor: CustomFactor) {
        self.id = customFactor.e
        self.factors = [:]
    }
    
    func resetColors() {
        print("RESETTING COLORS FOR \(id)")
        let allFactors = factors.values
        
        for factor in allFactors {
            factors[factor.f] = factor.resetChange()
        }
        print("done reseting colors")
    }
    func updateFactors(customFactor: CustomFactor) {
        print("CHANGING FACTOR FOR \(customFactor.e)")

        for factor in customFactor.factors {

            if let oldFactorModel = factors[factor.f] {
                //updating old value
                if oldFactorModel.v > factor.v {
                    //decreased
                    factors[factor.f] = FactorModel(factor: factor, change: .decrease)

                } else if oldFactorModel.v < factor.v {
                    //increased
                    factors[factor.f] = FactorModel(factor: factor, change: .increase)
                }
                
                print(".....was \(oldFactorModel.v) now \(factor.v)")
            } else {
                print("set new value")
                factors[factor.f] = FactorModel(factor: factor)
            }
        }
    }
}
