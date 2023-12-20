//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI
import Combine

final class AppSettingsViewModel: ObservableObject {
    @Published private(set) var settings: AppSettings
    @Published private(set) var interfaceSettings: AppInterfaceSettings
    @Published private(set) var soundSettings: AppSoundSettings
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        print("AppSettingsViewModel.\(#function)")
        settings = .init()
        soundSettings = .init()
        interfaceSettings = .init()
        
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.stopSounds()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { [weak self] _ in
                self?.stopSounds()
            }
            .store(in: &cancellables)
        
        prepareSounds()
    }
    
    func update() {
        print("AppSettingsViewModel.\(#function)")
        print("  interfaceSettings: \(interfaceSettings)")
        interfaceSettings.update()
        
        print("  interfaceSettings: \(interfaceSettings)")
    }
    
    func save(settingsVM: SettingsViewModel) {
        print("AppSettingsViewModel.\(#function)")
        
        print("  model: \(settings)")
        settings = AppSettings(
            attempts: settingsVM.attempts,
            timeForAnswer: settingsVM.timeForAnswer.secToMs//,
//            dartsWithMiss: settingsVM.dartsWithMiss,
//            dartImageName: settingsVM.dartImageName,
//            dartSize: settingsVM.dartSize,
//            dartsTargetPalette: .classic
        )
        
        settings.save()
        print("  model: \(settings)")
    }
    
    func prepareSounds() {
        Task {
            await MainActor.run {
//                SoundManager.shared.prepare(UserTapSound())
//                SoundManager.shared.prepare(TimerEndSound())
//                SoundManager.shared.prepare(DartsTargetRotationSound())
//                SoundManager.shared.prepare(GoodGameResultSound())
//                SoundManager.shared.prepare(BadGameResultSound())
            }
        }
    }

    func stopSounds() {
        Task {
            await MainActor.run { SoundManager.shared.stop() }
        }
    }
}
