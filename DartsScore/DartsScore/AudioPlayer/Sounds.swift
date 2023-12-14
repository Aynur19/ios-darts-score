//
//  Sounds.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 14.12.2023.
//

import Foundation

// source link: https://mixkit.co/free-sound-effects/click/ (Plastic bubble click)
struct UserTapSound: Sound {
    func getFileName() -> String {
        "UserTapSound"
    }
}

// source link: https://zvukipro.com/predmet/316-zvuk-taymera.html (Звук тикающего таймера 2 минуты)
struct TimerEndSound: Sound {
    func getFileName() -> String {
        "TimerEndSound"
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
