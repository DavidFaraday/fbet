//
//  AccountScreenModel.swift
//  Fonbet
//
//  Created by David Kababyan on 14/10/2024.
//

import Foundation


final class AccountScreenModel: ObservableObject {
    
    private let lineRepository: LineRepository
    private var packetVersion: Int?
    private var fetchingData = false
    
    @Published private(set) var sports: [SportModel] = []
//    private var events: [Event] = []
    
    private var eventModels: [EventModel] = []

    private var fetchingTask: Task<Void, Never>?
    
    
    init(lineRepository: LineRepository = .shared) {
        self.lineRepository = lineRepository
    }
    
    func events(for sportId: Int) -> [EventModel] {
        eventModels.filter( { $0.sportId == sportId && $0.level == 1 } )
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
            
            let lineData = try await lineRepository.fetchLine(with: packetVersion ?? 0)
            
            packetVersion = lineData.packetVersion

            eventModels = updateEvents(with: lineData.events)
            sports = updateSports(with: lineData.sports)

        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func updateSports(with newSports: [Sport]) -> [SportModel] {
        print("have \(newSports.count) new sports")
        
        let newModels = newSports.map( {SportModel(sport: $0) } )

        
        var tempSports = sports
        
        for updatedSport in newModels {
            if let existingIndex = tempSports.firstIndex(where: { $0.id == updatedSport.id }) {
                tempSports[existingIndex] = updatedSport
            } else {
                tempSports.append(updatedSport)
            }
        }
        
        return tempSports.map( { $0.setEventsDictionary(events: events(for: $0.id)) } )
    }
    
    func updateEvents(with newEvents: [Event]) -> [EventModel] {
        print("have \(newEvents.count) new events")
        
        let newEventModels = newEvents.map( { EventModel(event: $0) } )

        
        var tempEvents = eventModels
        
        for updatedEvent in newEventModels {
            if let existingIndex = tempEvents.firstIndex(where: { $0.id == updatedEvent.id }) {
                tempEvents[existingIndex] = updatedEvent
            } else {
                tempEvents.append(updatedEvent)
            }
        }

        return tempEvents
    }
//    
//    func createEventModels(from events: [Event]) {
//        print("have \(events.count) new")
//        
//        eventModel = events.map( { EventModel(event: $0)})
//    }
    
//    func events(for sportId: Int) -> [EventModel] {
//        eventModel.filter( { $0.sportId == sportId && $0.level == 1 } )
//    }

}
