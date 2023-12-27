//
//  DartsScoreApp.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

@main
struct DartsScoreApp: App {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentTabView()
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
