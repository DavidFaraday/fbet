//
//  SportsScreenModel.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import Foundation

final class SportsScreenModel: ObservableObject {
    
    private let lineRepository: LineRepository
    private var packetVersion = 0
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

            fetchingData = true
            
            let lineData = try await lineRepository.fetchLine(with: packetVersion)
            
            packetVersion = lineData.packetVersion
            
            updateSports(with: lineData.sports)
            updateEvents(with: lineData.events)
            resetFactorColors()
            updateFactors(with: lineData.customFactors)
            
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
        eventsDictionary.values.filter( { $0.sportID == sportId && $0.level == 1 } ).sorted()
    }
        
    
    /// Updates sports dictionary
    /// - Parameter newSports: latest sports
    private func updateSports(with newSports: [Sport]) {
        print("received news sports: \(newSports.count)")
        
        guard !newSports.isEmpty else { return }
        
        let newSportsDict = newSports.reduce(into: [:]) { $0[$1.id] = $1 }
        self.sportsDictionary.merge(newSportsDict) { (_, new) in new }
        
    }
    
    
    /// Updates events dictionary
    /// - Parameter newEvents: latest events
    private func updateEvents(with newEvents: [Event]) {
        print("received news events: \(newEvents.count)")

        guard !newEvents.isEmpty else { return }

        let newEventsDict = newEvents.reduce(into: [:]) { $0[$1.id] = $1 }
        self.eventsDictionary.merge(newEventsDict) { (_, new) in new }

    }
    
    
    /// Updates factors by setting factors dictionary with custom FactorModel
    /// - Parameter newFactors: Latest factors
    private func updateFactors(with newFactors: [CustomFactor]) {
        print("received news factors: \(newFactors.count)")
        
        guard !newFactors.isEmpty else { return }

        let newFactorDict: [Int: CustomFactorModel] = newFactors.reduce(into: [:]) { dict, factor in
            // Get the existing factor model or create a new one
            let factorModel = factorDictionary[factor.e] ?? CustomFactorModel(customFactor: factor)
            
            // Update the factor model with the new factor
            factorModel.updateFactors(customFactor: factor)
            
            dict[factor.e] = factorModel
        }
        
        self.factorDictionary.merge(newFactorDict) { (_, new) in new }
    }
    
    private func resetFactorColors() {
        factorDictionary.values.forEach { $0.resetColors() }
    }
}
