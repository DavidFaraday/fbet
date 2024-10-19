//
//  FactorType.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//


import Foundation

class Api {
    private let restUtils:RestUtilsProtocol
    
    init(
        restUtils: RestUtilsProtocol = RestUtils.shared
    ) {
        self.restUtils = restUtils
    }

    func interceptors() -> [Interceptor] {
        return []
    }

    @discardableResult
    func request(
        url: URL,
        method: HTTPMethod = .get,
        bodyType: BodyType? = nil,
        pathParameters: [String] = [],
        queryItems: [URLQueryItem] = [],
        headers:[String:String] = [:],
        interceptors: [Interceptor] = []
    ) async throws -> Response {
        return try await restUtils.request(
            url: url,
            method: method,
            bodyType: bodyType,
            pathParameters: pathParameters,
            queryItems: queryItems,
            headers: headers,
            interceptors: self.interceptors() + interceptors
        )
    }
}
