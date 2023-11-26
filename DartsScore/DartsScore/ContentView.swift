//
//  ContentView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DartsGameView()
                .tabItem {
                    Label("Дартс", systemImage: "gamecontroller")
                }
            
            DartsGameStatsView()
                .tabItem {
                    Label("Статистика", systemImage: "trophy")
                }
        }
    }
}

#Preview {
    ContentView()
}
