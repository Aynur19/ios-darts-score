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
    static let resultsMaxCount = 50
    
    static let gameJsonName = "DartsGame"
    static let statsJsonName = "DartsGameStats"
    static let answersCount = 5
    
    static let dartsTargetWidth: CGFloat = 350
    
    static let timerNotifyTime: Int = 5300
}
