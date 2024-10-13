//
//  SportsView.swift
//  Fonbet
//
//  Created by David Kababyan on 11/10/2024.
//

import SwiftUI

struct SportsScreen: View {
    
    @StateObject var viewModel = SportsScreenModel()
    @State var fetchingData = false
    
    @ViewBuilder
    func progressView() -> some View {
        if fetchingData {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
        
    @ViewBuilder
    func sportSection(sport: Sport) -> some View {
        Section {
            ForEach(viewModel.events(for: sport.id)) { event in

                EventRowView(
                    event: event,
                    factors: viewModel.factors(for: event.id)
                )
            }

        } header: {
            Text(sport.name)
                .font(.caption2)
        }
    }
    
    
    @ViewBuilder
    func main() -> some View {
        VStack(alignment: .leading) {
            TopSportsView(
                sports: viewModel.sportCategories,
                selectedSport: $viewModel.selectedSport
            )
            
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
                    fetchingData = true
                    
                    defer {
                        fetchingData = false
                    }
                    
                    await viewModel.listenForData()
                }
                .onDisappear() {
                    Task {
                        viewModel.stopListeningForData()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing, content: progressView)
                }
                .navigationTitle("Sports")
        }
    }
}

#Preview {
    SportsScreen()
}
