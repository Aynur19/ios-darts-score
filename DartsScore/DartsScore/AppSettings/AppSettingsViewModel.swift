//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI
import Combine

final class AppSettingsViewModel: ObservableObject {
    @Published private(set) var model: AppSettings
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        print("AppSettingsViewModel.\(#function)")
        model = .init()
        
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
    
    func prepareSounds() {
        Task {
            await MainActor.run {
                SoundManager.shared.prepare(UserTapSound())
                SoundManager.shared.prepare(TimerEndSound())
                SoundManager.shared.prepare(DartsRotationSound())
                SoundManager.shared.prepare(GoodGameResultSound())
                SoundManager.shared.prepare(BadGameResultSound())
            }
        }
    }


    func stopSounds() {
        Task {
            await MainActor.run { SoundManager.shared.stop() }
        }
    }
}
