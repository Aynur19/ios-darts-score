//
//  ContentView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView {
                DartsGameView()
                    .tabItem {
                        Label("Дартс", systemImage: "gamecontroller")
                            .foregroundStyle(AppSettings.shared.pallet.btnPrimaryColor)
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
                
                DartsGameStatsView()
                    .tabItem {
                        Label("История", systemImage: "trophy")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
            }
            .toolbarBackground(Color.red, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
