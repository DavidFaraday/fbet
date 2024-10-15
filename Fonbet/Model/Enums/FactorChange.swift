//
//  FactorChange.swift
//  Fonbet
//
//  Created by David Kababyan on 14/10/2024.
//

import SwiftUI

enum FactorChange {
    case increase
    case decrease
    case noChange
    
    var color: Color {
        switch self {
            case .increase:
                return .green
            case .decrease:
                return .red
            case .noChange:
                return .clear
        }
    }
}
