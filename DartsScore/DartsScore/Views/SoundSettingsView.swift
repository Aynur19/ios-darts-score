//
//  SoundSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import SwiftUI

struct SoundSettingsView: View {
    private typealias Defaults = AppSoundDefaultSettings
    private typealias Keys = AppSoundSettingsKeys
    
    @AppStorage(Keys.tapSoundIsEnabled.rawValue) 
    var tapSoundIsEnabled = Defaults.tapSoundIsEnabled
    
    @AppStorage(Keys.tapSoundVolume.rawValue)
    var tapSoundVolume = Defaults.tapSoundVolume
    
    @AppStorage(Keys.timerEndSoundIsEnabled.rawValue) 
    var timerEndSoundIsEnabled = Defaults.timerEndSoundIsEnabled
    
    @AppStorage(Keys.timerEndSoundVolume.rawValue)
    var timerEndSoundVolume = Defaults.timerEndSoundVolume
    
    @AppStorage(Keys.targetRotationSoundIsEnabled.rawValue) 
    var targetRotationSoundIsEnabled = Defaults.targetRotationSoundIsEnabled
    
    @AppStorage(Keys.targetRotationSoundVolume.rawValue) 
    var targetRotationSoundVolume = Defaults.targetRotationSoundVolume
    
    @AppStorage(Keys.gameResultSoundIsEnabled.rawValue) 
    var gameResultSoundIsEnabled = Defaults.gameResultSoundIsEnabled
    
    @AppStorage(Keys.gameGoodResultSoundVolume.rawValue) 
    var gameGoodResultSoundVolume = Defaults.gameGoodResultSoundVolume
    
    @AppStorage(Keys.gameBadResultSoundVolume.rawValue) 
    var gameBadResultSoundVolume = Defaults.gameBadResultSoundVolume
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    tapSoundSettings
                    timerEndSoundSettings
                    dartsTargetRotationSoundSettings
                    gameResultSoundSettings
                }
                .padding()
                .foregroundStyle(Palette.btnPrimary)
                .font(.headline)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("viewTitle_SoundSettings") // Настройки звука
                    .font(.title)
                    .foregroundStyle(Palette.bgText)
            }
        }
    }
    
    private var tapSoundSettings: some View {
        VStack(spacing: 16) {
            toggleButton(
                isOn: $tapSoundIsEnabled,
                label: { Text("label_TapSound") } // Нажатие / тап по кнопке
            )
            
            HStack(spacing: 32) {
                Slider(
                    value: Binding(
                        get: { self.tapSoundVolume },
                        set: { newValue in
                            self.tapSoundVolume = newValue
                            changeSoundVolume(tapSound)
                        }
                    ),
                    in: 0...1
                )
                .disabled(!tapSoundIsEnabled)
                
                soundButton(
                    isOn: tapSoundIsEnabled,
                    volume: tapSoundVolume,
                    action: { playAndStopSound(tapSound) }
                )
            }
        }
        .padding()
        .glowingOutline()
    }
    
    private var timerEndSoundSettings: some View {
        VStack(spacing: 16) {
            toggleButton(
                isOn: $timerEndSoundIsEnabled,
                label: { Text("label_TamerEndSound") } // Окончание таймера
            )
            
            HStack(spacing: 32) {
                Slider(
                    value: Binding(
                        get: { self.timerEndSoundVolume },
                        set: { newValue in
                            self.timerEndSoundVolume = newValue
                            changeSoundVolume(timerEndSound)
                        }
                    ),
                    in: 0...1
                )
                .disabled(!timerEndSoundIsEnabled)
                
                soundButton(
                    isOn: timerEndSoundIsEnabled,
                    volume: timerEndSoundVolume,
                    action: { playAndStopSound(timerEndSound) }
                )
            }
        }
        .padding()
        .glowingOutline()
    }
    
    private var dartsTargetRotationSoundSettings: some View {
        VStack(spacing: 16) {
            toggleButton(
                isOn: $targetRotationSoundIsEnabled,
                label: { Text("label_DartsTargetRotationSound") } // Поворот мишени
            )
            
            HStack(spacing: 32) {
                Slider(
                    value: Binding(
                        get: { self.targetRotationSoundVolume },
                        set: { newValue in
                            self.targetRotationSoundVolume = newValue
                            changeSoundVolume(dartsTargetRotationSound)
                        }),
                    in: 0...1
                )
                .disabled(!targetRotationSoundIsEnabled)
                
                soundButton(
                    isOn: targetRotationSoundIsEnabled,
                    volume: targetRotationSoundVolume,
                    action: { playAndStopSound(dartsTargetRotationSound) }
                )
            }
        }
        .padding()
        .glowingOutline()
    }

    private var gameResultSoundSettings: some View {
        VStack(spacing: 16) {
            toggleButton(
                isOn: $gameResultSoundIsEnabled,
                label: { Text("label_GameResultSound") } // Результат игры
            )
            
            HStack(spacing: 20) {
                Image(systemName: "hand.thumbsdown")
                Slider(
                    value: Binding(
                        get: { self.gameBadResultSoundVolume },
                        set: { newValue in
                            self.gameBadResultSoundVolume = newValue
                            changeSoundVolume(gameBadResultSound)
                        }
                    ),
                    in: 0...1
                )
                .disabled(!gameResultSoundIsEnabled)
                
                soundButton(
                    isOn: gameResultSoundIsEnabled,
                    volume: gameBadResultSoundVolume,
                    action: { playAndStopSound(gameBadResultSound) }
                )
            }
            
            HStack(spacing: 20) {
                Image(systemName: "hand.thumbsup")
                Slider(
                    value: Binding(
                        get: { self.gameGoodResultSoundVolume },
                        set: { newValue in
                            self.gameGoodResultSoundVolume = newValue
                            changeSoundVolume(gameGoodResultSound)
                        }
                    ),
                    in: 0...1
                )
                .disabled(!gameResultSoundIsEnabled)
                
                soundButton(
                    isOn: gameResultSoundIsEnabled,
                    volume: gameGoodResultSoundVolume,
                    action: { playAndStopSound(gameGoodResultSound) }
                )
            }
            
            HStack(spacing: 20) {
                Image(systemName: "hand.thumbsdown")
                Text("label_GameBadResultSound") // - звук при плохом результате
                Spacer()
            }
            
            HStack(spacing: 20) {
                Image(systemName: "hand.thumbsup")
                Text("label_GameGoodResultSound") // - звук при хорошем результате
                Spacer()
            }
        }
        .padding()
        .glowingOutline()
    }
    
    private var tapSound: Sound {
        UserTapSound(volume: tapSoundVolume.float)
    }
    
    private var timerEndSound: Sound {
        TimerEndSound(volume: timerEndSoundVolume.float)
    }
    
    private var dartsTargetRotationSound: Sound {
        DartsTargetRotationSound(volume: targetRotationSoundVolume.float)
    }
    
    private var gameGoodResultSound: Sound {
        GameGoodResultSound(volume: gameGoodResultSoundVolume.float)
    }
    
    private var gameBadResultSound: Sound {
        GameBadResultSound(volume: gameBadResultSoundVolume.float)
    }
}

extension SoundSettingsView {
    private func playAndStopSound(_ sound: Sound) {
        Task {
            await MainActor.run {
                SoundManager.shared.stop(excludedSounds: [sound])
                SoundManager.shared.playAndStop(sound: sound)
            }
        }
    }
    
    private func changeSoundVolume(_ sound: Sound) {
        Task {
            await MainActor.run {
                let player = SoundManager.shared.getAudioPlayer(sound, notBusy: false)
                player?.volume = sound.volume
            }
        }
    }
    
    private func toggleButton(
        isOn: Binding<Bool>,
        @ViewBuilder label: () -> Text
    ) -> some View {
        Toggle(
            isOn: isOn,
            label: { label() }
        )
        .toggleStyle(
            ImageToggleStyle(
                buttonChange: { isOn in
                    toggleButtonChange(isOn: isOn)
                },
                backgroundChange: { isOn in
                    toggleBackgroundChange(isOn: isOn)
                }
            )
        )
    }
    
    private func soundButton(
        isOn: Bool,
        volume: Double,
        action: @escaping () -> Void = { }
    ) -> some View {
        Button(
            action: { action() },
            label: {
                soundButtonImage(
                    isOn: isOn,
                    volume: volume
                )
                .font(.title2)
            }
        )
        .disabled(!isOn)
        .opacity(isOn ? 1 : 0.5)
        .frame(width: 32, height: 32)
        .padding(.horizontal, 8)
    }
    
    private func toggleButtonChange(isOn: Bool) -> some View {
        Circle()
            .fill(Palette.btnPrimary)
            .overlay {
                Image(systemName: isOn ? "checkmark" : "xmark")
                    .foregroundStyle(Palette.btnPrimaryText)
            }
            .padding(2)
    }
    
    private func toggleBackgroundChange(isOn: Bool) -> Color {
        isOn ? Palette.btnPrimary.opacity(0.5) : Color(.systemGray4)
    }
    
    private func soundButtonImage(isOn: Bool, volume: Double) -> Image {
        if !isOn {
            Image(systemName: "speaker.slash")
        } else {
            if volume < 0.25 {
                Image(systemName: "speaker")
            } else if volume < 0.5 {
                Image(systemName: "speaker.wave.1")
            } else if volume < 0.75 {
                Image(systemName: "speaker.wave.2")
            } else {
                Image(systemName: "speaker.wave.3")
            }
        }
    }
}

private struct TestSoundSettingsView: View {
    var body: some View {
        NavigationStack {
            SoundSettingsView()
        }
    }
}

#Preview {
    TestSoundSettingsView()
}
