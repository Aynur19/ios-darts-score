//
//  AppSettingsConstants.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 13.12.2023.
//

import Foundation

struct AppSettingsConstants {
    static let attemptsCountData = [5, 10, 15, 20]
    static let defaultAttemptsIdx = 1
    static let defaultAttempts = attemptsCountData[defaultAttemptsIdx]
    
    static let timesForAnswerData = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    static let defaultTimeForAnswerIdx = timesForAnswerData.count - 1
    static let defaultTimeForAnswer = timesForAnswerData[defaultTimeForAnswerIdx]
    
    static let defaultDartsWithMiss = true
    
    static let dartImageNamesData: [DartImage] = [
        .dart1, .dart2, .dart3, .dart4, .dart5, .dart6, .dart7,
        .dartFlipH1, .dartFlipH2,
        .dart1Rotate180
    ]
    
    static let defaultDartImageNameIdx = 0
    static let defaultDartImageName = dartImageNamesData[defaultDartImageNameIdx]
    static let defaultDartSize = 26
    
    static let defaultDartsTargetPalette: DartsTargetPalette = .classic
}
