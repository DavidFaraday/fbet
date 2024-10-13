//
//  RestUtils.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

enum BodyType {
    case json(Encodable)
    case urlEncoded(Encodable)
}

protocol RestUtilsProtocol {
    func request(
        url: URL,
        method: HTTPMethod,
        bodyType: BodyType?,
        pathParameters: [String],
        queryItems: [URLQueryItem],
        headers:[String:String],
        interceptors: [Interceptor]
    ) async throws -> Response
}

class RestUtils: NSObject, RestUtilsProtocol, URLSessionDelegate {
    
    static let shared = RestUtils()
    
    private let urlEncoder:URLEncodedFormEncoderProtocol
    private let jsonUtils:JsonUtilsProtocol
    
    init(urlEncoder: URLEncodedFormEncoderProtocol = URLEncodedFormEncoder.shared,
         jsonUtils:JsonUtilsProtocol = JsonUtils.shared
         
    ) {
        self.urlEncoder = urlEncoder
        self.jsonUtils = jsonUtils
    }
    
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    func request(
        url: URL,
        method: HTTPMethod = .get,
        bodyType: BodyType? = nil,
        pathParameters: [String] = [],
        queryItems: [URLQueryItem] = [],
        headers:[String:String] = [:],
        interceptors: [Interceptor] = []
    ) async throws -> Response {
        
        var tempURL = url
        
        if !queryItems.isEmpty {
            tempURL = tempURL.appending(queryItems: queryItems)
        }
        
        for pathParameter in pathParameters {
            tempURL = tempURL.appending(path: pathParameter)
        }
        
        var request = URLRequest( url: tempURL)
        request.httpMethod = method.rawValue
        
        for header in headers where !header.value.isEmpty{
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let bodyType {
            switch bodyType {
            case .json(let body):
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(body)
            case .urlEncoded(let body):
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpBody = try urlEncoder.encode(body)
            }
        }
        
        for interceptor in interceptors {
            request = try await interceptor.interceptRequest(request: request)
        }
        
        var response = try await execute(request: request)
        
        for interceptor in interceptors {
            var retries = [URL: Int]()
            response = try await interceptor.interceptResponse(request: request, response: response, retry: { _, _ in
                return try await self.retry(retries: &retries, interceptor: interceptor, request: request, response: response)
            })
            
            retries[tempURL] = 0
        }
        
        return response
    }
    
    private func retry(retries:inout [URL: Int], interceptor: Interceptor, request: URLRequest, response: Response) async throws -> Response {
        guard interceptor.retries > 0 else {
            return  try await execute(request: request)
        }
        
        if let url = request.url, let existingRetries = retries[url], existingRetries < interceptor.retries {
            retries[url] = (retries[url] ?? 0) + 1
            return  try await execute(request: request)
        }
        
        return response
    }
    
    private func execute(request: URLRequest) async throws -> Response {
        let (data, urlResponse) = try await session.data(for: request)
        return try Response(
            urlResponse: urlResponse,
            receivedData: data,
            jsonDecoder: jsonUtils.decoder
        )
    }
}

struct Response {
    let httpUrlResponse: HTTPURLResponse
    let headers: [AnyHashable: Any]?
    let receivedData: Data?
    let jsonDecoder:JSONDecoder?
    
    
    
    var json: NSString? {
        return receivedData?.prettyString
    }
    
    var statusCode: Int {
        return httpUrlResponse.statusCode
    }
    
    func data<T>() throws(NetworkError) -> T where T: Decodable {
        guard let receivedData else {
            throw .invalidEncoding
        }
        
        let decoder =  jsonDecoder ?? JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: receivedData)
        } catch {
            throw .invalidEncoding
        }
    }
    
    init(
        urlResponse: URLResponse,
        receivedData: Data?,
        jsonDecoder:JSONDecoder?
    ) throws {
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        self.jsonDecoder = jsonDecoder
        self.receivedData = receivedData
        self.httpUrlResponse = httpUrlResponse
        self.headers = httpUrlResponse.allHeaderFields
    }
}
