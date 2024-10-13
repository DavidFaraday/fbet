//
//  Date + Extension.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import Foundation

extension Date {
    
    func formattedRelativeToToday() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today at \(self.formatted(date: .omitted, time: .shortened))"
        }
        
        if calendar.isDateInTomorrow(self) {
            return "Tomorrow at \(self.formatted(date: .omitted, time: .shortened))"
        }
        
        return "\(self.formatted(date: .abbreviated, time: .shortened))"
    }
}
