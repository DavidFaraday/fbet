//
//  Data + Extension.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

extension Data {
    var prettyString: NSString? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) ?? nil
    }
}

extension URLQueryItem {
    
    init(name:String,value:Int) {
        self.init(name: name, value: value.description)
    }
}
