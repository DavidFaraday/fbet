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
    func sportSection(sport: Sport) -> some View {
        Section {
//            ForEach(viewModel.events(for: sport.id)) { event in
//                Text(event.team1 ?? "no t1")
//                Text(event.team2 ?? "no t2")
////                EventRowView(
////                    event: event,
////                    factors: viewModel.factors(for: event.id)
////                )
//            }

        } header: {
            Text(sport.name)
                .font(.caption2)
        }
    }
    

    
//    @ViewBuilder
//    func main() -> some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("s: \(viewModel.lineDataModel?.sportsDictionary.values.count ?? 0)")
//                Text("e: \(viewModel.lineDataModel?.eventsDictionary.values.count ?? 0)")
//                Text("f: \(viewModel.lineDataModel?.factorDictionary.values.count ?? 0)")
//                Text("pv: \(viewModel.lineDataModel?.packetVersion ?? 0)")
//            }
//            .padding()
//            
//            List(viewModel.sports) { sport in
//                sportSection(sport: sport)
//            }
//            .listStyle(.plain)
//        }
//    }

    
    
    var body: some View {
        NavigationStack {
            Text("d")
                .task {
//                    await viewModel.listenForData()
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
