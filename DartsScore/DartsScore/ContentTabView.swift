//
//  ContentTabView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct ContentTabView: View {
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    var body: some View {
        ZStack {
            TabView {
                TabItemView(
                    contentView: { DartsGameView() },
                    labelView: { Label("viewTitle_Darts", systemImage: "gamecontroller") }
                )
                
                TabItemView(
                    contentView: { GamesResultsView() },
                    labelView: { Label("viewTitle_Statistics", systemImage: "trophy") }
                )
                
                TabItemView(
                    contentView: { AppSettingsView(settings: appSettingsVM.settings) },
                    labelView: { Label("viewTitle_AppSettings", systemImage: "gear") }
                )
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
