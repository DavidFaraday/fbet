//
//  TabBarView.swift
//  Fonbet
//
//  Created by David Kababyan on 13/10/2024.
//

import SwiftUI

struct TabBarView: View {
    
    var body: some View {
        TabView {
            SportsScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            AccountScreen()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Account")
                }
            
        }
    }
}
