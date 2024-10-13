//
//  NetworkError.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

struct LocalizedErrorWrapper:LocalizedError {
    private let title: String
    private let message: String?
    
    init(title: String, message: String?) {
        self.title = title
        self.message = message
    }
    
    var errorTitle: String? {
        title
    }
    
    var failureReason: String? {
        message
    }
    
    var errorDescription: String? {
        message
    }
    
    var localizableErrorDescription: String? {
        message
    }
}

enum NetworkError: LocalizedError {
    case unknownError
    case cancelled
    case invalidEncoding
    case custom(error: Error)

    var errorDescription: LocalizedErrorWrapper? {
        switch self {
        case .unknownError, .invalidEncoding:
            return LocalizedErrorWrapper(title: "Something went wrong", message: nil)
        case .cancelled:
            return nil
        case .custom(let error):
            return  LocalizedErrorWrapper(title: error.localizedDescription, message: nil)
        }
        
    }
}
