//
//  SoundEnums.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 14.12.2023.
//

import Foundation

enum SoundFileExtension: String {
    case mp3
}

enum SoundEnum {
    case userTap
    case timerEnd
    case dartsTargetRotation
    case gameGoodResult
    case gameBadResult
    
    var sound: Sound {
        switch self {
            case .userTap: 
                return UserTapSound()
            case .timerEnd: 
                return TimerEndSound()
            case .dartsTargetRotation: 
                return DartsTargetRotationSound()
            case .gameBadResult: 
                return GameBadResultSound()
            case .gameGoodResult: 
                return GameGoodResultSound()
        }
    }
}
