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
                
                AppSettingsView(appSettings: appSettingsVM.model)
                    .tabItem {
                        Label("viewTitle_AppSettings", systemImage: "gear")

                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
            .onAppear {
                DispatchQueue.global().async {
                    SoundManager.shared.prepare(UserTapSound())
                    SoundManager.shared.prepare(TimerEndSound())
                    SoundManager.shared.prepare(DartsRotationSound())
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                SoundManager.shared.stop()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                SoundManager.shared.stop()
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
