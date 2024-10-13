//
//  LineRepository.swift
//  Fonbet
//
//  Created by David Kababyan on 12/10/2024.
//

import Foundation

protocol LineRepositoryProtocol {
    func fetchLine(with packetVersion: Int) async throws -> LineData
}

final class LineRepository: LineRepositoryProtocol {
    private let fonbetAPI: FonbetAPIProtocol
    
    static let shared = LineRepository()
    
    init(api: FonbetAPIProtocol = FonbetAPI.shared) {
        self.fonbetAPI = api
    }
    
    
    /// Fetches line data from the API
    /// - Parameter packetVersion: previous packet version or 0
    /// - Returns: LineData object
    func fetchLine(with packetVersion: Int) async throws -> LineData {
        try await fonbetAPI.fetchLine(with: packetVersion)
    }
}

