//
//  AppSoundSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import SwiftUI

private struct AppSoundSettingsViewConstants {
    static let vSpacing: CGFloat = 20
    static let hSpacing: CGFloat = 32
    static let vSpasingInner: CGFloat = 16
    
    static let soundVolumeRange: ClosedRange<Double> = 0...1
}

struct AppSoundSettingsView: View {
    private typealias Defaults = AppSoundDefaultSettings
    private typealias Keys = AppSoundSettingsKeys
    private typealias Constants = AppSoundSettingsViewConstants
    
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
                VStack(spacing: Constants.vSpacing) {
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
            StaticUI.toolbarTitle { Text("viewTitle_SoundSettings") }
        }
    }
    
    // MARK: Tap Sound
    private var tapSoundSettings: some View {
        VStack(spacing: Constants.vSpasingInner) {
            toggleButton(
                isOn: $tapSoundIsEnabled,
                label: { Text("label_TapSound") }
            )
            
            HStack(spacing: Constants.hSpacing) {
                Slider(
                    value: Binding(
                        get: { self.tapSoundVolume },
                        set: { newValue in onChangeTapSoundVolume(volume: newValue) }
                    ),
                    in: Constants.soundVolumeRange
                )
                .disabled(!tapSoundIsEnabled)
                
                soundButton(
                    isOn: tapSoundIsEnabled,
                    volume: tapSoundVolume,
                    action: { playAndStopSound(.userTap) }
                )
            }
        }
        .padding()
        .glowingOutline()
    }
    
    private func onChangeTapSoundVolume(volume: Double) {
        tapSoundVolume = volume
        changeSoundVolume(.userTap, volume: volume.float)
    }
    
    // MARK: Timer End Sound
    private var timerEndSoundSettings: some View {
        VStack(spacing: Constants.vSpasingInner) {
            toggleButton(
                isOn: $timerEndSoundIsEnabled,
                label: { Text("label_TamerEndSound") }
            )
            
            HStack(spacing: Constants.hSpacing) {
                Slider(
                    value: Binding(
                        get: { self.timerEndSoundVolume },
                        set: { newValue in onChangeTimerEndSoundVolume(volume: newValue) }
                    ),
                    in: Constants.soundVolumeRange
                )
                .disabled(!timerEndSoundIsEnabled)
                
                soundButton(
                    isOn: timerEndSoundIsEnabled,
                    volume: timerEndSoundVolume,
                    action: { playAndStopSound(.timerEnd) }
                )
            }
        }
        .padding()
        .glowingOutline()
    }
    
    private func onChangeTimerEndSoundVolume(volume: Double) {
        timerEndSoundVolume = volume
        changeSoundVolume(.timerEnd, volume: volume.float)
    }
    
    // MARK: Target Rotation Sound
    private var dartsTargetRotationSoundSettings: some View {
        VStack(spacing: Constants.vSpasingInner) {
            toggleButton(
                isOn: $targetRotationSoundIsEnabled,
                label: { Text("label_DartsTargetRotationSound") }
            )
            
            HStack(spacing: Constants.hSpacing) {
                Slider(
                    value: Binding(
                        get: { self.targetRotationSoundVolume },
                        set: { newValue in onChangeTargetRotationSoundVolume(volume: newValue) }
                    ),
                    in: Constants.soundVolumeRange
                )
                .disabled(!targetRotationSoundIsEnabled)
                
                soundButton(
                    isOn: targetRotationSoundIsEnabled,
                    volume: targetRotationSoundVolume,
                    action: { playAndStopSound(.dartsTargetRotation) }
                )
            }
        }
        .padding()
        .glowingOutline()
    }
    
    private func onChangeTargetRotationSoundVolume(volume: Double) {
        targetRotationSoundVolume = volume
        changeSoundVolume(.dartsTargetRotation, volume: volume.float)
    }

    // MARK: Game Result Sound
    private var gameResultSoundSettings: some View {
        VStack(spacing: Constants.vSpasingInner) {
            toggleButton(
                isOn: $gameResultSoundIsEnabled,
                label: { Text("label_GameResultSound") }
            )
            
            gameGoodSoundVolumeSettings
            gameBadSoundvolumeSettings
            gameResultSoundIImageDescriptions
        }
        .padding()
        .glowingOutline()
    }
    
    private var gameBadSoundvolumeSettings: some View {
        HStack(spacing: Constants.hSpacing) {
            Image(systemName: "hand.thumbsdown")
            Slider(
                value: Binding(
                    get: { self.gameBadResultSoundVolume },
                    set: { newValue in onChangeGameBadResultSoundVolume(volume: newValue) }
                ),
                in: Constants.soundVolumeRange
            )
            .disabled(!gameResultSoundIsEnabled)
            
            soundButton(
                isOn: gameResultSoundIsEnabled,
                volume: gameBadResultSoundVolume,
                action: { playAndStopSound(.gameBadResult) }
            )
        }
    }
    
    private var gameGoodSoundVolumeSettings: some View {
        HStack(spacing: Constants.hSpacing) {
            Image(systemName: "hand.thumbsup")
            Slider(
                value: Binding(
                    get: { self.gameGoodResultSoundVolume },
                    set: { newValue in onChangeGameGoodResultSoundVolume(volume: newValue) }
                ),
                in: Constants.soundVolumeRange
            )
            .disabled(!gameResultSoundIsEnabled)
            
            soundButton(
                isOn: gameResultSoundIsEnabled,
                volume: gameGoodResultSoundVolume,
                action: { playAndStopSound(.gameGoodResult) }
            )
        }
    }
    
    private var gameResultSoundIImageDescriptions: some View {
        VStack(spacing: Constants.vSpacing.half) {
            HStack(spacing: Constants.hSpacing.half) {
                Image(systemName: "hand.thumbsup")
                Text("label_GameGoodResultSound")
                Spacer()
            }
            
            HStack(spacing: Constants.hSpacing.half) {
                Image(systemName: "hand.thumbsdown")
                Text("label_GameBadResultSound")
                Spacer()
            }
        }
        .font(.caption)
    }
    
    private func onChangeGameGoodResultSoundVolume(volume: Double) {
        gameGoodResultSoundVolume = volume
        changeSoundVolume(.gameGoodResult, volume: volume.float)
    }
    
    private func onChangeGameBadResultSoundVolume(volume: Double) {
        gameBadResultSoundVolume = volume
        changeSoundVolume(.gameBadResult, volume: volume.float)
    }
    
    private func playAndStopSound(_ soundId: SoundEnum) {
        Task {
            await MainActor.run {
                SoundManager.shared.stop(excludedSoundsIds: [soundId])
                SoundManager.shared.playAndStop(soundId: soundId)
            }
        }
    }
    
    private func changeSoundVolume(_ soundId: SoundEnum, volume: Float) {
        Task {
            await MainActor.run {
                let player = SoundManager.shared.getAudioPlayer(soundId, notBusy: false)
                player?.volume = volume
            }
        }
    }
    
    private func toggleButton( isOn: Binding<Bool>, @ViewBuilder label: () -> Text) -> some View {
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
    
    private func soundButton(isOn: Bool, volume: Double, action: @escaping () -> Void = {}) -> some View {
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
            AppSoundSettingsView()
        }
    }
}

#Preview {
    TestSoundSettingsView()
}
