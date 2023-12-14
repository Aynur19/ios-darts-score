//
//  AppSettings.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

class AppConstants: ObservableObject {
    //
    static let standardTimeForAnswer = 60.secToMs
    static let statsMaxCount = 50
    static let wireRadiusesCount = 6
    
    static let gameJsonName = "DartsGame"
    static let statsJsonName = "DartsGameStats"
    static let answersCount = 5
    
    static let dartsFrameWidth: CGFloat = 350
    static let dartsCount = 3
    
    // default data
    static let attemptsCountData = [5, 10, 15, 20]
    static let defaultAttemptsIdx = 1
    static let defaultAttempts = attemptsCountData[defaultAttemptsIdx]
    
    static let timesForAnswerData = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    static let defaultTimeForAnswerIdx = timesForAnswerData.count - 1
    static let defaultTimeForAnswer = timesForAnswerData[defaultTimeForAnswerIdx]
    
    static let defaultDartsWithMiss = true
    
    static let dartImageNamesData: [DartImageName] = [
        .dart1, .dart2, .dart3, .dart4, .dart5, .dart6, .dart7,
        .dartFlipH1, .dartFlipH2,
        .dart1Rotate180
    ]
    
    static let defaultDartImageNameIdx = 0
    static let defaultDartImageName = dartImageNamesData[defaultDartImageNameIdx]
    static let defaultDartSize = 26
    
    static let defaultDartsTargetPalette: DartsTargetPalette = .classic

    
    // MARK: Timer options
    static let timerCircleLineWidth: CGFloat = 8

    static let timerCircleDownColor: Color = .gray
    static let timerCiclreDownOpacity: CGFloat = 0.3

    static let timerCircleUpColor: Color = .green
    static let timerCiclreUpOpacity: CGFloat = 1
    static let timerCircleUpRotation: Angle = .degrees(-90)

    static let timerAnimationDuration: CGFloat = 0.2
    static let timerTextFont: Font = .headline
    static let timerTextColor: Color = .green
    static let timerTextIsBold: Bool = true
    static let timerTextFormat: TimerStringFormat = .secMs
    
    static let timerTimeLeftToNotify: Int = 5300
}
