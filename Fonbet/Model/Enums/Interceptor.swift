//
//  Interceptor.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

typealias Retry = (URLRequest, Response) async throws -> Response

protocol Interceptor {
    func interceptRequest(request: URLRequest) async throws -> URLRequest

    func interceptResponse(request: URLRequest, response: Response, retry: Retry) async throws -> Response

    var retries: Int { get }
}

extension Interceptor {
    func interceptRequest(request: URLRequest) async throws -> URLRequest {
        return request
    }

    func interceptResponse(request: URLRequest, response: Response, retry: Retry) async throws -> Response {
        return response
    }

    var retries: Int {
        return 0
    }
}
