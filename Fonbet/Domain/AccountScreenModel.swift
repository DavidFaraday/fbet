//
//  AccountScreenModel.swift
//  Fonbet
//
//  Created by David Kababyan on 14/10/2024.
//

import Foundation


final class AccountScreenModel: ObservableObject {
    
    private let lineRepository: LineRepository
    private var fetchingData = false
    private var packetVersion = 0
    
    
    private var fetchingTask: Task<Void, Never>?
    
    
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
            self.packetVersion = lineData.packetVersion

            
        } catch {
            print("Error: \(error)")
        }
    }
}
