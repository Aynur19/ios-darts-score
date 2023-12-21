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
        settings.update()
        interfaceSettings.update()
        soundSettings.update()
        
        prepareSounds()
    }
    
    func prepareSounds() {
        Task {
            await MainActor.run {
                SoundManager.shared.prepare(UserTapSound(volume: soundSettings.tapSoundVolume.float))
                SoundManager.shared.prepare(TimerEndSound(volume: soundSettings.timerEndSoundVolume.float))
                SoundManager.shared.prepare(DartsTargetRotationSound(volume: soundSettings.targetRotationSoundVolume.float))
                SoundManager.shared.prepare(GameGoodResultSound(volume: soundSettings.gameGoodResultSoundVolume.float))
                SoundManager.shared.prepare(GameBadResultSound(volume: soundSettings.gameBadResultSoundVolume.float))
            }
        }
    }

    func stopSounds() {
        Task { await MainActor.run { SoundManager.shared.stop() } }
    }
}
