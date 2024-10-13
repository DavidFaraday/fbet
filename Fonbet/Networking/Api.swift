//
//  SalesforceApi.swift
//  B2C
//
//  Created by Christos Chadjikyriacou on 06/10/2023.
//  Copyright © 2023 B2C. All rights reserved.
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
