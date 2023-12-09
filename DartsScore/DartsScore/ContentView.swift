//
//  ContentView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    var body: some View {
        ZStack {
            TabView {
                DartsGameView(appSettingsVM.model)
                    .tabItem {
                        Label("viewTitle_Darts", systemImage: "gamecontroller")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                DartsGameResultsView()
                    .tabItem {
                        Label("viewTitle_Statistics", systemImage: "trophy")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                AppSettingsView()
                    .tabItem {
                        Label("viewTitle_AppSettings", systemImage: "gear")

                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

private struct TestContentView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ContentView()
                .environment(\.mainWindowSize, geometry.size)
                .environmentObject(appSettingsVM)
        }
    }
}

#Preview {
    TestContentView()
}
