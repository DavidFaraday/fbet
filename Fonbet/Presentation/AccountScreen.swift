//
//  SecondScreen.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import SwiftUI

struct AccountScreen: View {
    
    @StateObject var viewModel = AccountScreenModel()
    
    @ViewBuilder
    func sportSection(sport: SportModel) -> some View {
        Section {
            ForEach(sport.events) { event in
                VStack(alignment: .leading) {
                    Text(event.team1 ?? "no team 1")
                    Text(event.team2 ?? "no team 2")
                }
//                EventRowView(
//                    event: event,
//                    factors: viewModel.factors(for: event.id)
//                )
            }

        } header: {
            Text(sport.name)
                .font(.caption2)
        }
    }
    

    
    @ViewBuilder
    func main() -> some View {
        VStack(alignment: .leading) {
            
            List(viewModel.sports) { sport in
                sportSection(sport: sport)
            }
            .listStyle(.plain)
        }
    }

    
    
    var body: some View {
        NavigationStack {
            main()
                .task {
                    await viewModel.listenForData()
                }
                .onDisappear() {
                    Task {
                        viewModel.stopListeningForData()
                    }
                }
                .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountScreen()
}
