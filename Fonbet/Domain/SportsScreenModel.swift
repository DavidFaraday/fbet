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
        eventsDictionary.values.filter( { $0.sportId == sportId && $0.level == 1 } ).sorted()
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
            
            let start = Date()
            packetVersion = lineData.packetVersion
            
            updateSports(with: lineData.sports)
            updateEvents(with: lineData.events)
            resetFactorColors()
            updateFactors(with: lineData.customFactors)
            
            print("finished all in \(Date().timeIntervalSince(start))")
            print("***********")

        } catch {
            print("Error: \(error)")
        }
    }
    
    private func updateSports(with newSports: [Sport]) {
        let start = Date()
        updateDictionary(dictionary: &sportsDictionary, with: newSports)
        print("updating sports took \(Date().timeIntervalSince(start)) seconds")
        print("------------")
    }

    private func updateEvents(with newEvents: [Event]) {
        let start = Date()
        updateDictionary(dictionary: &eventsDictionary, with: newEvents)
        
        print("updating events took \(Date().timeIntervalSince(start)) seconds")
        print("------------")
    }

    
    private func updateDictionary<T: Identifiable>(dictionary: inout [Int: T], with newItems: [T]) {
        
        guard !newItems.isEmpty else { return }
                       
        let newItemsDict:[Int: T] = newItems.reduce(into: [:]) { dict, item in

            guard let intID = item.id as? Int else { return }
            dict[intID] = item
        }
        
        dictionary.merge(newItemsDict) { (_, new) in new }
    }
        
        
    
    /// Updates factors by setting factors dictionary with custom FactorModel
    /// - Parameter newFactors: Latest factors
    private func updateFactors(with newFactors: [CustomFactor]) {
        print("received news factors: \(newFactors.count)")
        
        guard !newFactors.isEmpty else { return }
        let start = Date()
        
        let newFactorDict: [Int: CustomFactorModel] = newFactors.reduce(into: [:]) { dict, factor in
            // Get the existing factor model or create a new one
            let factorModel = factorDictionary[factor.e] ?? CustomFactorModel(customFactor: factor)
            
            // Update the factor model with the new factor
            factorModel.updateFactors(customFactor: factor)
            
            dict[factor.e] = factorModel
        }
        
        self.factorDictionary.merge(newFactorDict) { (_, new) in new }
        print("updated factors: \(Date().timeIntervalSince(start))")
        print("------------")

    }
    
    private func resetFactorColors() {
        let start = Date()
        factorDictionary.values.forEach { $0.resetColors() }
        print("reset factor colors: \(Date().timeIntervalSince(start))")
        print("------------")

    }
}
