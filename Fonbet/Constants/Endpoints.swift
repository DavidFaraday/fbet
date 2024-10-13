//
//  Endpoints.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

protocol EndpointsProtocol {
    
    func listURL() -> URL
    func eventsURL() -> URL
}

class Endpoints: EndpointsProtocol {
    
    static let shared = Endpoints()
    
    private func host() -> URL {
        URL(string: "https://line03w.bk6bba-resources.com")!
    }
    
    func eventsURL() -> URL {
        host().appending(component: "events")
    }
    
    
    func listURL() -> URL {
        eventsURL().appending(component: "list")
    }
    
    
    
}
