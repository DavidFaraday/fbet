//
//  Double + Extension.swift
//  Fonbet
//
//  Created by David Kababyan on 12/10/2024.
//

import Foundation

extension Double {
    var toTwoDecimalPlaces: String {
        return String(format: "%.2f", self)
    }
}
