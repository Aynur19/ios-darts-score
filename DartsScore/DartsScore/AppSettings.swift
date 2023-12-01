//
//  AppSettings.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

enum DartImageSystemName: String {
    case xmark
}

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    private init() {}
    
    static let standardTimeForAnswer = 60.secToMs
    static let statsMaxCount = 50
    static let wireRadiusesCount = 6
    
    static let statsJsonFileName = "DartsGameStats"
    static let gameJsonFileName = "DartsGame"
    static let answersCount = 5
    
    private(set) var dartsFrameWidth: CGFloat = 350 // 512
    private(set) var dartsCount = 3
    
    @Published private(set) var points25Color: Color = .green
    @Published private(set) var bullEyeColor: Color = .red
    @Published private(set) var wireColor: Color = .gray
    @Published private(set) var baseColors: [Color] = [.white, .black]
    @Published private(set) var xColors: [Color] = [.red, .green]
    
    @Published private(set) var dartImageSize: CGFloat = 16 // 24
    @Published private(set) var dartImageName: DartImageSystemName = .xmark
    @Published private(set) var dartImageColor: Color = .blue
    
    @Published private(set) var dartsSectorNumberColor: Color = .white
    
    @Published private(set) var attempts = 10
    @Published private(set) var timeForAnswer = 60000
    
    func getSectorColor(for sectorIdx: Int, _ isBaseSector: Bool = true) -> Color {
        isBaseSector ? baseColors[sectorIdx % 2] : xColors[sectorIdx % 2]
    }
    
    // MARK: Timer options
    let timerCircleLineWidth: CGFloat = 8

    let timerCircleDownColor: Color = .gray
    let timerCiclreDownOpacity: CGFloat = 0.3

    let timerCircleUpColor: Color = .green
    let timerCiclreUpOpacity: CGFloat = 1
    let timerCircleUpRotation: Angle = .degrees(-90)

    let timerAnimationDuration: CGFloat = 0.2
    let timerTextFont: Font = .headline
    let timerTextColor: Color = .green
    let timerTextIsBold: Bool = true
    let timerTextFormat: TimerStringFormat = .secMs
}
