//
//  SportsScreenModel.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

final class SportsScreenModel: ObservableObject {
    
    private let lineRepository: LineRepository
    private var packetVersion: Int?
    private var fetchingData = false
    
    @Published private var sportsDictionary: [Int: Sport] = [:]
    @Published private var eventsDictionary: [Int: Event] = [:]
    @Published private var factorDictionary: [Int: CustomFactorModel] = [:]
        
    private var fetchingTask: Task<Void, Never>?
    
    
    var sports: [Sport] {
        sportsDictionary.values.sorted()
    }
    
    init(lineRepository: LineRepository = .shared) {
        self.lineRepository = lineRepository
    }
    
    
    /// Start listening for Line data with refreshing every 5 seconds
    func listenForData() async {
        print("Started listening for Line data.")
        
        fetchingTask = Task {
            while !Task.isCancelled {
                await fetchLineData()
                try? await Task.sleep(for: .seconds(5))
                
                if Task.isCancelled {
                    print("Task was cancelled.")
                    break
                }
            }
        }
    }
    
    
    /// Stop listening for line data. Used when the user leaves the screen
    func stopListeningForData() {
        print("Stoped listening for Line data.")
        fetchingTask?.cancel()
    }
    
    
    /// Fetches new line data and updates the current one with the latest info
    @MainActor
    func fetchLineData() async {

        guard !fetchingData else { return }
        
        defer { fetchingData = false }
        
        do {
            print("Fetching line data...")
            fetchingData = true
            
            let lineData = try await lineRepository.fetchLine(with: packetVersion ?? 0)
            
            packetVersion = lineData.packetVersion
            
            updateSports(with: lineData.sports)
            updateEvents(with: lineData.events)
            resetFactorColors()
            updateFactors(with: lineData.customFactors)
            
            
            print("Done fetching")
            print("___________________")
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    
    /// Gets factors for the specific Event, currently returns only (1, X, 2) factors
    /// - Parameter eventId: EventId you need factors for
    /// - Returns: Array of Factors
    func factors(for eventId: Int) -> [FactorModel] {
        factorDictionary[eventId]?
            .factors.values
            .filter({
                $0.f == FactorType.one.rawValue ||
                $0.f == FactorType.draw.rawValue ||
                $0.f == FactorType.two.rawValue
            })
            .sorted() ?? []
    }
    
    /// Gets the level 1 events for the selected sport
    /// - Parameter sportId: SportId that you need events for
    /// - Returns: Array of Level 1 Events
    func events(for sportId: Int) -> [Event] {
        eventsDictionary.values.filter( { $0.sportID == sportId && $0.level == 1 } )
    }
        
    
    /// Updates sports dictionary
    /// - Parameter newSports: latest sports
    private func updateSports(with newSports: [Sport]) {
        print("allSports: \(newSports.count)")

        var tempSportsDictionary = sportsDictionary
        
        for sport in newSports {
            tempSportsDictionary[sport.id] = sport
        }
        
        sportsDictionary = tempSportsDictionary
    }
    
    
    /// Updates events dictionary
    /// - Parameter newEvents: latest events
    private func updateEvents(with newEvents: [Event]) {
        print("mainEvents: \(newEvents.count)")

        var tempEventsDictionary = eventsDictionary
        
        for event in newEvents {
            tempEventsDictionary[event.id] = event
        }
        
        eventsDictionary = tempEventsDictionary
    }
    
    
    /// Updates factors by setting factors dictionary with custom FactorModel
    /// - Parameter newFactors: Latest factors
    private func updateFactors(with newFactors: [CustomFactor]) {
        print("allFactors: \(newFactors.count)")
        
        var tempFactorDictionary = factorDictionary
        
        for factor in newFactors {
                        
            let factorModel = factorDictionary[factor.e] ?? CustomFactorModel(customFactor: factor)
            
            factorModel.updateFactors(customFactor: factor)
            
            tempFactorDictionary[factor.e] = factorModel
        }
        
        factorDictionary = tempFactorDictionary
    }
    
    private func resetFactorColors() {
        let allFactors = factorDictionary.values
        
        for factor in allFactors {
            factor.resetColors()
        }
    }
}
