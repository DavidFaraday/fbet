//
//  JsonUtilsProtocol.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

protocol JsonUtilsProtocol {
    
    var encoder:JSONEncoder { get }
    var decoder:JSONDecoder { get }
}


class JsonUtils:JsonUtilsProtocol {
    
    static let shared = JsonUtils()
    
    init() {
        
    }
       
    lazy var encoder:JSONEncoder  = {
        JSONEncoder()
    }()
    
    lazy var decoder:JSONDecoder  = {
        JSONDecoder()
    }()
    
    
}
