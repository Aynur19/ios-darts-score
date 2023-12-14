//
//  Sound.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 13.12.2023.
//

import Foundation
import AVFoundation

enum SoundFileExtension: String {
    case mp3
}

protocol Sound {
    var url: URL? { get }
    
    func getFileName() -> String
    func getFileExtension() -> String
    
    func getVolume() -> Float
    func getNumberOfLoops() -> Int
    func enableRate() -> Bool
    func getRate() -> Float
}

extension Sound {
    var url: URL? {
        Bundle.main.url(forResource: getFileName(), withExtension: getFileExtension())
    }
    
    func getFileExtension() -> String {
        SoundFileExtension.mp3.rawValue
    }
    
    func getVolume() -> Float { 1 }
    func getNumberOfLoops() -> Int { 0 }
    func enableRate() -> Bool { false }
    func getRate() -> Float { 1 }
}

// source link: https://mixkit.co/free-sound-effects/click/ (Plastic bubble click)
struct DartsGameAnswerTapSound: Sound {
    func getFileName() -> String {
        "tap"
    }
}

// source link: https://zvukipro.com/predmet/316-zvuk-taymera.html (Звук тикающего таймера 2 минуты)
struct TimerEndSound: Sound {
    func getFileName() -> String {
        "timer"
    }
    
    func getVolume() -> Float { 0.05 }
}

// source link: https://pixabay.com/ru/sound-effects/slow-whoosh-118247/
struct DartsRotationSound: Sound {
    func getFileName() -> String {
        "DartsTargetRotation"
    }
    
    func getVolume() -> Float { 0.05 }
}

// source link: https://tuna.voicemod.net/sound/6463ea42-f474-4157-a232-9f0718051257
struct GoodGameResultSound: Sound {
    func getFileName() -> String {
        "GoodGameResultSound"
    }
}

// source link: https://zvukipro.com/mult/1606-zvuki-iz-multseriala-rik-i-morti.html (Музыка "For The Damaged Coda")
struct BadGameResultSound: Sound {
    func getFileName() -> String {
        "BadGameResultSound"
    }
}


// original source: https://stackoverflow.com/questions/36865233/get-avaudioplayer-to-play-multiple-sounds-at-a-time/71582181#71582181
final class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()

    private var audioPlayers: [URL: AVAudioPlayer] = [:]
    private var duplicateAudioPlayers: [AVAudioPlayer] = []

    private override init() {}
    
    func prepare(_ sound: Sound) {
        guard let player = getAudioPlayer(sound) else { return }
        
        player.volume = sound.getVolume()
        player.numberOfLoops = sound.getNumberOfLoops()
        
        if sound.enableRate() {
            player.enableRate = true
            player.rate = sound.getRate()
        }
        
        player.prepareToPlay()
    }

    func play(_ sound: Sound) {
        guard let player = getAudioPlayer(sound) else { return }
        
        player.volume = sound.getVolume()
        player.numberOfLoops = sound.getNumberOfLoops()
        
        if sound.enableRate() {
            player.enableRate = true
            player.rate = sound.getRate()
        }
        player.currentTime = 0
        
        player.prepareToPlay()
        player.play()
    }
    
    func stop() {
        audioPlayers.forEach { _, player in
            player.stop()
        }
        
        duplicateAudioPlayers.forEach { player in
            player.stop()
        }
    }
    
    func stop(_ sound: Sound, onPause: Bool = false) {
        guard let url = sound.url,
              let player = audioPlayers[url]
        else  { return }
        
        if onPause {
            player.pause()
        } else {
            player.stop()
            player.currentTime = 0
        }
    }
    
    func getAudioPlayer(_ sound: Sound) -> AVAudioPlayer? {
        guard let url = sound.url else { return nil }
        
        return getAudioPlayer(for: url)
    }

    private func getAudioPlayer(for url: URL) -> AVAudioPlayer? {
        print("SoundManager.\(#function)")
        print(" duplicate Audio Players: \(duplicateAudioPlayers.count)")
        
        guard let player = audioPlayers[url] else {
            let player = try? AVAudioPlayer(contentsOf: url)
            audioPlayers[url] = player
            
            return player
        }
        
        guard player.isPlaying else { return player }
        
        guard let duplicatePlayer = try? AVAudioPlayer(contentsOf: url) else { return nil }
        
        duplicatePlayer.delegate = self
        duplicateAudioPlayers.append(duplicatePlayer)
        
        return duplicatePlayer
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        duplicateAudioPlayers.removeAll { $0 == player }
    }
}
