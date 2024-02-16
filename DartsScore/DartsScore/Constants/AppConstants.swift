//
//  AppSettings.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

/// Checking that the screen is being displayed on Preview or on the simulator/device.
var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

final class AppConstants: ObservableObject {
    static let gameJsonName = "DartsGame"
    static let statsJsonName = "DartsGameStats"
    
    /// Maximum number of records in game history.
    static let recordsMaxCount = 50
    
    /// The number of answer options for each question in the game.
    static let answersCount = 5
    
    /// The default width (diameter) of a dartboard.
    static let dartsTargetWidth: CGFloat = 350
    
    /// The number of milliseconds before the timer starts counting (sound playback).
    static let timerNotifyTime: Int = 5300
}
