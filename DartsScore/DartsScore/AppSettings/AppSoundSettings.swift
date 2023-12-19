//
//  AppSoundSettings.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 18.12.2023.
//

import Foundation

struct AppSoundDefaultSettings {
    static let tapSoundIsEnabled = true
    static let tapSoundVolume: Double = 0.5
    
    static let timerEndSoundIsEnabled = true
    static let timerEndSoundVolume: Double = 0.5
    
    static let targetRotationSoundIsEnabled = true
    static let targetRotationSoundVolume: Double = 0.5
    
    static let gameResultSoundIsEnabled = true
    static let gameGoodResultSoundVolume: Double = 0.5
    static let gameBadResultSoundVolume: Double = 0.5
}

enum AppSoundSettingsKeys: String {
    case tapSoundIsEnabled
    case tapSoundVolume
    
    case timerEndSoundIsEnabled
    case timerEndSoundVolume
    
    case targetRotationSoundIsEnabled
    case targetRotationSoundVolume
    
    case gameResultSoundIsEnabled
    case gameGoodResultSoundVolume
    case gameBadResultSoundVolume
}

struct AppSoundSettings {
    private typealias Defaults = AppSoundDefaultSettings
    private typealias Keys = AppSoundSettingsKeys
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var tapSoundIsEnabled: Bool
    private(set) var tapSoundVolume: Double
    
    private(set) var timerEndSoundIsEnabled: Bool
    private(set) var timerEndSoundVolume: Double
    
    private(set) var targetRotationSoundIsEnabled: Bool
    private(set) var targetRotationSoundVolume: Double
    
    private(set) var gameResultSoundIsEnabled: Bool
    private(set) var gameGoodResultSoundVolume: Double
    private(set) var gameBadResultSoundVolume: Double
    
    init() {
        Self.registerSettings()
        
        tapSoundIsEnabled   = userDefaults.bool(forKey: Keys.tapSoundIsEnabled.rawValue)
        tapSoundVolume      = userDefaults.double(forKey: Keys.tapSoundVolume.rawValue)
        
        timerEndSoundIsEnabled  = userDefaults.bool(forKey: Keys.timerEndSoundIsEnabled.rawValue)
        timerEndSoundVolume     = userDefaults.double(forKey: Keys.timerEndSoundVolume.rawValue)
        
        targetRotationSoundIsEnabled    = userDefaults.bool(forKey: Keys.targetRotationSoundIsEnabled.rawValue)
        targetRotationSoundVolume       = userDefaults.double(forKey: Keys.targetRotationSoundVolume.rawValue)
        
        gameResultSoundIsEnabled    = userDefaults.bool(forKey: Keys.gameResultSoundIsEnabled.rawValue)
        gameGoodResultSoundVolume   = userDefaults.double(forKey: Keys.gameGoodResultSoundVolume.rawValue)
        gameBadResultSoundVolume    = userDefaults.double(forKey: Keys.gameBadResultSoundVolume.rawValue)
    }
    
    init(
        tapSoundIsEnabled: Bool,
        tapSoundVolume: Double,
        timerEndSoundIsEnabled: Bool,
        timerEndSoundVolume: Double,
        targetRotationSoundIsEnabled: Bool,
        targetRotationSoundVolume: Double,
        gameResultSoundIsEnabled: Bool,
        gameGoodResultSoundVolume: Double,
        gameBadResultSoundVolume: Double
    ) {
        print("AppSettings.\(#function)")
        
        self.tapSoundIsEnabled = tapSoundIsEnabled
        self.tapSoundVolume = tapSoundVolume
        
        self.timerEndSoundIsEnabled = timerEndSoundIsEnabled
        self.timerEndSoundVolume = timerEndSoundVolume
        
        self.targetRotationSoundIsEnabled = targetRotationSoundIsEnabled
        self.targetRotationSoundVolume = targetRotationSoundVolume
        
        self.gameResultSoundIsEnabled = gameResultSoundIsEnabled
        self.gameGoodResultSoundVolume = gameGoodResultSoundVolume
        self.gameBadResultSoundVolume = gameBadResultSoundVolume
    }
    
    private static func registerSettings() {
        UserDefaults.standard.register(
            defaults: [
                Keys.tapSoundIsEnabled.rawValue: Defaults.tapSoundIsEnabled,
                Keys.tapSoundVolume.rawValue: Defaults.tapSoundVolume,
                
                Keys.timerEndSoundIsEnabled.rawValue: Defaults.timerEndSoundIsEnabled,
                Keys.timerEndSoundVolume.rawValue: Defaults.timerEndSoundVolume,
                
                Keys.targetRotationSoundIsEnabled.rawValue: Defaults.targetRotationSoundIsEnabled,
                Keys.targetRotationSoundVolume.rawValue: Defaults.targetRotationSoundVolume,
                
                Keys.gameResultSoundIsEnabled.rawValue: Defaults.gameResultSoundIsEnabled,
                Keys.gameGoodResultSoundVolume.rawValue: Defaults.gameGoodResultSoundVolume,
                Keys.gameBadResultSoundVolume.rawValue: Defaults.gameBadResultSoundVolume,
            ]
        )
    }
    
    func save() {
        userDefaults.setValue(tapSoundIsEnabled, forKey: Keys.tapSoundIsEnabled.rawValue)
        userDefaults.setValue(tapSoundVolume, forKey: Keys.tapSoundVolume.rawValue)
        
        userDefaults.setValue(timerEndSoundIsEnabled, forKey: Keys.timerEndSoundIsEnabled.rawValue)
        userDefaults.setValue(timerEndSoundVolume, forKey: Keys.timerEndSoundVolume.rawValue)
        
        userDefaults.setValue(targetRotationSoundIsEnabled, forKey: Keys.targetRotationSoundIsEnabled.rawValue)
        userDefaults.setValue(targetRotationSoundVolume, forKey: Keys.targetRotationSoundVolume.rawValue)
        
        userDefaults.setValue(gameResultSoundIsEnabled, forKey: Keys.gameResultSoundIsEnabled.rawValue)
        userDefaults.setValue(gameGoodResultSoundVolume, forKey: Keys.gameGoodResultSoundVolume.rawValue)
        userDefaults.setValue(gameBadResultSoundVolume, forKey: Keys.gameBadResultSoundVolume.rawValue)
    }
}
