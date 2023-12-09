//
//  ContentView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        ZStack {
            TabView {
                DartsGameView(appSettingsVM.model)
                    .environmentObject(appSettingsVM)
                    .tabItem {
                        Label("viewTitle_Darts", systemImage: "gamecontroller")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                DartsGameResultsView()
                    .environmentObject(appSettingsVM)
                    .tabItem {
                        Label("viewTitle_Statistics", systemImage: "trophy")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                AppSettingsView()
                    .environmentObject(appSettingsVM)
                    .tabItem {
                        Label("viewTitle_AppSettings", systemImage: "gear")

                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
