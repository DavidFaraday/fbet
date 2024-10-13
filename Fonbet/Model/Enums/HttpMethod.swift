//
//  HttpMethod.swift
//  B2C
//
//  Created by Christos Chadjikyriacou on 05/10/2023.
//  Copyright © 2023 B2C. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}
