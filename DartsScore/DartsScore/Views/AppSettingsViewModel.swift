//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

final class AppSettingsViewModel: ObservableObject {
    @Published private(set) var model: AppSettings
    
    init() {
        print("AppSettingsViewModel.\(#function)")
        model = .init()
    }
    
    func save(settingsVM: SettingsViewModel) {
        print("AppSettingsViewModel.\(#function)")
        
        print("  model: \(model)")
        model = AppSettings(
            attempts: settingsVM.attempts,
            timeForAnswer: settingsVM.timeForAnswer.secToMs,
            dartsWithMiss: settingsVM.dartsWithMiss,
            dartImageName: settingsVM.dartImageName,
            dartSize: settingsVM.dartSize,
            dartsTargetPalette: .classic
        )
        
        model.save()
        print("  model: \(model)")
    }
}
