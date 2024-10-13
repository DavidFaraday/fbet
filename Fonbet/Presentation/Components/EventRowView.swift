//
//  EventRowView.swift
//  Fonbet
//
//  Created by David Kababyan on 12/10/2024.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    let factors: [Factor]
    
    @ViewBuilder
    func factorsView() -> some View {
        HStack {
            ForEach(factors, id: \.self) { factor in
                VStack(spacing: 5) {
                    if let title = FactorType(rawValue: factor.f)?.title {
                        Text(title)
                    }
                    
                    Text(factor.v.toTwoDecimalPlaces)
                }
                .font(.caption)
                .padding(5)
                .border(.secondary)
            }
        }
    }
    
    @ViewBuilder
    func eventInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {

            Text(
                Date(timeIntervalSince1970: TimeInterval(event.startTime))
                .formattedRelativeToToday()
            )
            .font(.caption)
            
            if let team1 = event.team1 {
                Text(team1)
            }
            
            if let team2 = event.team2 {
                Text(team2)
            }
        }
        .font(.callout)
    }
    
    var body: some View {
        HStack {
            eventInfoView()
            
            Spacer()
            
            factorsView()
        }
    }
}
