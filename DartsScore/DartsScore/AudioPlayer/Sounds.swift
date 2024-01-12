//
//  Sounds.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 14.12.2023.
//

import Foundation

// source link: https://mixkit.co/free-sound-effects/click/ (Plastic bubble click)
struct UserTapSound: Sound {
    var volume: Float = 1
    
    func getFileName() -> String { "UserTapSound" }
}

// source link: https://zvukipro.com/predmet/316-zvuk-taymera.html (Звук тикающего таймера 2 минуты)
struct TimerEndSound: Sound {
    var volume: Float = 1
    
    func getFileName() -> String { "TimerEndSound" }
}

// source link: https://pixabay.com/ru/sound-effects/slow-whoosh-118247/
struct DartsTargetRotationSound: Sound {
    var volume: Float = 1
    
    func getFileName() -> String { "DartsTargetRotation" }
}

// source link: https://tuna.voicemod.net/sound/6463ea42-f474-4157-a232-9f0718051257
struct GameGoodResultSound: Sound {
    var volume: Float = 1
    
    func getFileName() -> String { "GoodGameResultSound" }
}

// source link: https://zvukipro.com/mult/1606-zvuki-iz-multseriala-rik-i-morti.html (Музыка "For The Damaged Coda")
struct GameBadResultSound: Sound {
    var volume: Float = 1
    
    func getFileName() -> String { "BadGameResultSound" }
}
