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

private struct DartsTargetSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 350
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
    
    var dartsTargetSize: CGFloat {
        get { self[DartsTargetSizeKey.self] }
        set { self[DartsTargetSizeKey.self] = newValue }
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
                    .environment(\.dartsTargetSize, dartsTargetSize(geometry))
                    .environmentObject(appSettingsVM)
                    .preferredColorScheme(.dark)
            }
        }
    }
    
    private func dartsTargetSize(_ geometry: GeometryProxy) -> CGFloat {
        DartsConstants.getDartsTargetWidth(windowsSize: geometry.size)
    }
}
