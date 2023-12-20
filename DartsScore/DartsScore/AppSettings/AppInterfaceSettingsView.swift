//
//  AppInterfaceSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import Foundation

struct AppInterfaceDefaultSettings {
    static let dartImageNamesData: [DartImageName] = [
        .dart1, .dart2, .dart3, .dart4, .dart5,
        .dartFlipH1, .dartFlipH2,
        .dart1Rotate180
    ]
    static let dartImageNameIdx = 0
    static let dartImageName = dartImageNamesData[dartImageNameIdx]
    
    static let dartSize = 30
    
    static let dartsTargetPalette: DartsTargetPalette = .classic
}

enum AppInterfaceSettingsKeys: String {        
    case dartImageName
    case dartSize
    
    case dartsTargetPalette
}

struct AppInterfaceSettings {
    private typealias Defaults = AppInterfaceDefaultSettings
    private typealias Keys = AppInterfaceSettingsKeys
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var dartImageName: DartImageName
    private(set) var dartSize: Int
    
    private(set) var dartsTargetPalette: DartsTargetPalette
    
    init() {
        Self.registerSettings()
        
        dartImageName       = Self.loadDartImageName()
        dartSize            = userDefaults.integer(forKey: Keys.dartSize.rawValue)
        dartsTargetPalette  = Self.loadDartsTargetPalette()
    }
    
//    init(
//        dartImageName: Bool,
//        dartSize: Double,
//        dartsTargetPalette: Bool,
//        timerEndSoundVolume: Double,
//        targetRotationSoundIsEnabled: Bool,
//        targetRotationSoundVolume: Double,
//        gameResultSoundIsEnabled: Bool,
//        gameGoodResultSoundVolume: Double,
//        gameBadResultSoundVolume: Double
//    ) {
//        print("AppSettings.\(#function)")
//        
//        self.tapSoundIsEnabled = tapSoundIsEnabled
//        self.tapSoundVolume = tapSoundVolume
//        
//        self.timerEndSoundIsEnabled = timerEndSoundIsEnabled
//        self.timerEndSoundVolume = timerEndSoundVolume
//        
//        self.targetRotationSoundIsEnabled = targetRotationSoundIsEnabled
//        self.targetRotationSoundVolume = targetRotationSoundVolume
//        
//        self.gameResultSoundIsEnabled = gameResultSoundIsEnabled
//        self.gameGoodResultSoundVolume = gameGoodResultSoundVolume
//        self.gameBadResultSoundVolume = gameBadResultSoundVolume
//    }
    
    private static func registerSettings() {
        UserDefaults.standard.register(
            defaults: [
                Keys.dartImageName.rawValue: Defaults.dartImageName.rawValue,
                Keys.dartSize.rawValue: Defaults.dartSize,
                Keys.dartsTargetPalette.rawValue: Defaults.dartsTargetPalette.rawValue
            ]
        )
    }
    
    func save() {
        userDefaults.setValue(dartImageName.rawValue, forKey: Keys.dartImageName.rawValue)
        userDefaults.setValue(dartSize, forKey: Keys.dartSize.rawValue)
        userDefaults.setValue(dartsTargetPalette.rawValue, forKey: Keys.dartsTargetPalette.rawValue)
    }
    
    private static func loadDartImageName() -> DartImageName {
        guard let rawValue = UserDefaults.standard.string(forKey: Keys.dartImageName.rawValue) else {
            return Defaults.dartImageName
        }
        
        return .init(rawValue: rawValue) ?? Defaults.dartImageName
    }
    
    private static func loadDartsTargetPalette() -> DartsTargetPalette {
        guard let rawValue = UserDefaults.standard.string(forKey: Keys.dartsTargetPalette.rawValue) else {
            return Defaults.dartsTargetPalette
        }
        
        return .init(rawValue: rawValue) ?? Defaults.dartsTargetPalette
    }
}
