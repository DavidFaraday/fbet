//
//  LineAPI.swift
//  Fonbet
//
//  Created by David Kababyan on 12/10/2024.
//

import Foundation

protocol FonbetAPIProtocol {
    func fetchLine(with packetVersion: Int) async throws -> LineData
}


final class FonbetAPI: Api, FonbetAPIProtocol {
    
    private let endpoints: EndpointsProtocol

    static let shared = FonbetAPI()

    
    init(endpoints: EndpointsProtocol = Endpoints.shared) {
        self.endpoints = endpoints
    }

    
    
    /// Fetch line data currently hardcoded language to english
    /// - Parameter packetVersion: previous package version or 0
    /// - Returns: LineData object
    func fetchLine(with packetVersion: Int) async throws -> LineData {

        let response = try await request(
            url: endpoints.listURL(),
            queryItems: [
                URLQueryItem(name: "lang", value: "en"),
                URLQueryItem(name: "version", value: packetVersion),
                URLQueryItem(name: "scopeMarket", value: 1600)
            ])

        
        return try response.data()
    }
}
