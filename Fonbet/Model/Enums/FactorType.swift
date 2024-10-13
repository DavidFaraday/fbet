//
//  FactorType.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

enum FactorType: Int {
    case one = 921
    case draw = 922
    case two = 923
    
    var title: String {
        switch self {
            case .one:
                return "1"
            case .draw:
                return "X"
            case .two:
                return "2"
        }
    }
}
