//
//  ContentTabView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI
import SwiftUIComponents4iOS

struct ContentTabView: View {
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    var body: some View {
        ZStack {
            TabView {
                DartsGameView()
                    .tabItem { Label("viewTitle_Darts", systemImage: "gamecontroller") }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                GamesResultsView()
                    .tabItem { Label("viewTitle_Statistics", systemImage: "trophy") }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
                
                AppSettingsView(settings: appSettingsVM.settings)
                    .tabItem { Label("viewTitle_AppSettings", systemImage: "gear") }
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
            ContentTabView()
                .environment(\.mainWindowSize, geometry.size)
                .environment(\.dartsTargetSize,
                              DartsConstants.getDartsTargetWidth(windowsSize: geometry.size))
                .environmentObject(appSettingsVM)
        }
    }
}

#Preview {
    TestContentView()
}
