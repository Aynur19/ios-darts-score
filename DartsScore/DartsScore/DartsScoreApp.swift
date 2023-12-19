//
//  DartsScoreApp.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}

@main
struct DartsScoreApp: App {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentView()
                    .environment(\.mainWindowSize, geometry.size)
                    .environmentObject(appSettingsVM)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
