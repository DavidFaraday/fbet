//
//  SecondScreen.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import SwiftUI

struct AccountScreen: View {
    var body: some View {
        NavigationStack {
            Text("This view is made to test the if the app stops fetching data when moved to other screen")
                .multilineTextAlignment(.center)
                .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountScreen()
}
