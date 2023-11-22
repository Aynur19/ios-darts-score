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
                    Image(systemName: "gamecontroller")
                }
            
            DartsGameStatsView()
                .tabItem {
                    Image(systemName: "trophy")
                }
        }
    }
}

#Preview {
    ContentView()
}
