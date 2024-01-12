//
//  SoundManager.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 14.12.2023.
//

import AVFoundation

// original source: 
// https://stackoverflow.com/questions/36865233/get-avaudioplayer-to-play-multiple-sounds-at-a-time/71582181#71582181
@MainActor
final class SoundManager: NSObject {
    static let shared = SoundManager()

    private var settings: AppSoundSettings = .init()
    private var audioPlayers: [SoundEnum: AVAudioPlayer] = [:]
    private var duplicateAudioPlayers: [AVAudioPlayer] = []

    private override init() {}
    
    func prepare(settings: AppSoundSettings) {
        self.settings = settings
        
        audioPlayers.removeAll()
        duplicateAudioPlayers.removeAll()
        
        var volume = settings.tapSoundIsEnabled ? settings.tapSoundVolume.float : 0
        prepare(.userTap, volume: volume)
        
        volume = settings.timerEndSoundIsEnabled ? settings.timerEndSoundVolume.float : 0
        prepare(.timerEnd, volume: volume)
        
        
        volume = settings.targetRotationSoundIsEnabled ? settings.targetRotationSoundVolume.float : 0
        prepare(.dartsTargetRotation, volume: volume)
        
        volume = settings.gameResultSoundIsEnabled ? settings.gameGoodResultSoundVolume.float : 0
        prepare(.gameGoodResult, volume: volume)
        
        volume = settings.gameResultSoundIsEnabled ? settings.gameBadResultSoundVolume.float : 0
        prepare(.gameBadResult, volume: volume)
    }
    
    func prepare(_ soundId: SoundEnum, volume: Float) {
        guard let player = getAudioPlayer(soundId) else { return }
        
        let sound = soundId.sound
        
        player.volume = volume
        player.numberOfLoops = sound.getNumberOfLoops()
        player.enableRate = sound.enableRate()
        player.rate = sound.getRate()
        
        player.prepareToPlay()
    }

    func play(_ soundId: SoundEnum, isRestart: Bool = true) {
        guard let player = audioPlayers[soundId] else { return }
        
        if isRestart {
            player.currentTime = .zero
        }
        
        player.prepareToPlay()
        player.play()
    }
    
    func playAndStop(soundId: SoundEnum) {
        let player: AVAudioPlayer
        
        if let foundedPlayer = audioPlayers[soundId] {
            player = foundedPlayer
        } else {
            if let url = soundId.sound.url,
               let createdPlayer = try? AVAudioPlayer(contentsOf: url) {
                player = createdPlayer
                audioPlayers[soundId] = player
            } else { return }
        }
        
        if player.isPlaying {
            player.stop()
            return
        }
        
        player.currentTime = 0
        player.volume = soundId.sound.volume
        player.prepareToPlay()
        player.play()
    }
    
    func stop(excludedSoundsIds: [SoundEnum] = []) {
        if excludedSoundsIds.isEmpty {
            audioPlayers.forEach { _, player in
                player.stop()
            }
        } else {
            audioPlayers.forEach { id, player in
                if !excludedSoundsIds.contains(id) {
                    player.stop()
                }
            }
        }
        
        duplicateAudioPlayers.forEach { player in
            player.stop()
        }
    }
    
    func stop(_ soundId: SoundEnum, onPause: Bool = false) {
        guard let player = audioPlayers[soundId] else { return }
        
        if onPause {
            player.pause()
        } else {
            player.stop()
        }
    }
    
    func getAudioPlayer(_ soundId: SoundEnum, notBusy: Bool = true) -> AVAudioPlayer? {
        let sound = soundId.sound
        guard let url = sound.url else { return nil }
        
        guard let player = audioPlayers[soundId] else {
            let player = try? AVAudioPlayer(contentsOf: url)
            audioPlayers[soundId] = player
            
            return player
        }
        
        if !notBusy { return player }
        
        guard player.isPlaying else { return player }
        
        guard let duplicatePlayer = try? AVAudioPlayer(contentsOf: url) else { return nil }
        
        duplicatePlayer.delegate = self
        duplicateAudioPlayers.append(duplicatePlayer)
        
        return duplicatePlayer
    }
}
//final class SoundManager: NSObject {
//    static let shared = SoundManager()
//
//    private var settings: AppSoundSettings = .init()
//    private var audioPlayers: [URL: AVAudioPlayer] = [:]
//    private var duplicateAudioPlayers: [AVAudioPlayer] = []
//
//    private override init() {}
//    
//    func prepare(settings: AppSoundSettings) {
//        self.settings = settings
//        
//        audioPlayers.removeAll()
//        duplicateAudioPlayers.removeAll()
//        
//        if settings.tapSoundIsEnabled {
//            prepare(UserTapSound(volume: settings.tapSoundVolume.float))
//        }
//        
//        if settings.timerEndSoundIsEnabled {
//            prepare(TimerEndSound(volume: settings.timerEndSoundVolume.float))
//        }
//        
//        if settings.targetRotationSoundIsEnabled {
//            prepare(DartsTargetRotationSound(volume: settings.targetRotationSoundVolume.float))
//        }
//        
//        if settings.gameResultSoundIsEnabled {
//            prepare(GameGoodResultSound(volume: settings.gameGoodResultSoundVolume.float))
//            prepare(GameBadResultSound(volume: settings.gameBadResultSoundVolume.float))
//        }
//    }
//    
//    func prepare(_ sound: Sound) {
//        guard let player = getAudioPlayer(sound) else { return }
//        
//        player.volume = sound.volume
//        player.numberOfLoops = sound.getNumberOfLoops()
//        
//        if sound.enableRate() {
//            player.enableRate = true
//            player.rate = sound.getRate()
//        }
//        
//        player.prepareToPlay()
//    }
//
//    func play(_ sound: Sound, isRestart: Bool = true) {
//        print("SoundManager.\(#function)")
//        print("  sound: \(sound)")
//        guard let url = sound.url,
//              let player = audioPlayers[url]
//        else { return }
//        
//        if isRestart {
//            player.currentTime = .zero
//        }
//        
//        player.prepareToPlay()
//        player.play()
//    }
//    
//    func playAndStop(sound: Sound) {
//        let player: AVAudioPlayer
//        
//        if let url = sound.url {
//            if let foundedPlayer = audioPlayers[url] {
//                player = foundedPlayer
//            } else if let createdPlayer = try? AVAudioPlayer(contentsOf: url) {
//                player = createdPlayer
//                audioPlayers[url] = player
//            } else { return }
//            
//            if player.isPlaying {
//                player.stop()
//                return
//            }
//            
//            player.currentTime = 0
//            player.volume = sound.volume
//            player.prepareToPlay()
//            player.play()
//        }
//    }
//    
//    func stop(excludedSounds: [Sound] = []) {
//        let excludedUrls = excludedSounds.compactMap { $0.url }
//        
//        if excludedUrls.isEmpty {
//            audioPlayers.forEach { _, player in
//                player.stop()
//            }
//        } else {
//            audioPlayers.forEach { url, player in
//                if !excludedUrls.contains(url) {
//                    player.stop()
//                }
//            }
//        }
//        
//        duplicateAudioPlayers.forEach { player in
//            player.stop()
//        }
//    }
//    
//    func stop(_ sound: Sound, onPause: Bool = false) {
//        guard let url = sound.url,
//              let player = audioPlayers[url]
//        else { return }
//        
//        if onPause {
//            player.pause()
//        } else {
//            player.stop()
//        }
//    }
//    
//    func getAudioPlayer(_ sound: Sound, notBusy: Bool = true) -> AVAudioPlayer? {
//        print("SoundManager.\(#function)")
//        print(" duplicate Audio Players: \(duplicateAudioPlayers.count)")
//        
//        guard let url = sound.url else { return nil }
//        
//        guard let player = audioPlayers[url] else {
//            let player = try? AVAudioPlayer(contentsOf: url)
//            audioPlayers[url] = player
//            
//            return player
//        }
//        
//        if !notBusy { return player }
//        
//        guard player.isPlaying else { return player }
//        
//        guard let duplicatePlayer = try? AVAudioPlayer(contentsOf: url) else { return nil }
//        
//        duplicatePlayer.delegate = self
//        duplicateAudioPlayers.append(duplicatePlayer)
//        
//        return duplicatePlayer
//    }
//}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task {
            await MainActor.run { duplicateAudioPlayers.removeAll { $0 == player } }
        }
    }
}
