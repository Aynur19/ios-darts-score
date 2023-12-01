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
                        Label("viewTitle_Darts", systemImage: "gamecontroller")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
                
                DartsGameResultsView()
                    .tabItem {
                        Label("viewTitle_Statistics", systemImage: "trophy")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
