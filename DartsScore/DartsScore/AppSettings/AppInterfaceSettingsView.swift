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
    
    static let dartMissesIsEnabled = true
    
    static let dartsTargetPalette: DartsTargetPalette = .classic
}

enum AppInterfaceSettingsKeys: String {        
    case dartImageName
    case dartSize
    case dartMissesIsEnabled
    case dartsTargetPalette
}

struct AppInterfaceSettings {
    private typealias Defaults = AppInterfaceDefaultSettings
    private typealias Keys = AppInterfaceSettingsKeys
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var dartImageName: DartImageName
    private(set) var dartSize: Int
    private(set) var dartMissesIsEnabled: Bool
    private(set) var dartsTargetPalette: DartsTargetPalette
    
    init() {
        Self.registerSettings()
        
        dartImageName       = Self.loadDartImageName()
        dartSize            = userDefaults.integer(forKey: Keys.dartSize.rawValue)
        dartMissesIsEnabled = userDefaults.bool(forKey: Keys.dartMissesIsEnabled.rawValue)
        dartsTargetPalette  = Self.loadDartsTargetPalette()
    }
    
    private static func registerSettings() {
        UserDefaults.standard.register(
            defaults: [
                Keys.dartImageName.rawValue: Defaults.dartImageName.rawValue,
                Keys.dartSize.rawValue:             Defaults.dartSize,
                Keys.dartMissesIsEnabled.rawValue:  Defaults.dartMissesIsEnabled,
                Keys.dartsTargetPalette.rawValue:   Defaults.dartsTargetPalette.rawValue
            ]
        )
    }
    
    func save() {
        userDefaults.setValue(dartImageName.rawValue, forKey: Keys.dartImageName.rawValue)
        userDefaults.setValue(dartSize, forKey: Keys.dartSize.rawValue)
        userDefaults.setValue(dartMissesIsEnabled, forKey: Keys.dartMissesIsEnabled.rawValue)
        userDefaults.setValue(dartsTargetPalette.rawValue, forKey: Keys.dartsTargetPalette.rawValue)
    }
    
    mutating func update() {
        dartImageName       = Self.loadDartImageName()
        dartSize            = userDefaults.integer(forKey: Keys.dartSize.rawValue)
        dartMissesIsEnabled = userDefaults.bool(forKey: Keys.dartMissesIsEnabled.rawValue)
        dartsTargetPalette  = Self.loadDartsTargetPalette()
    }
    
    var dartImageNameIdx: Int {
        guard let idx = Defaults.dartImageNamesData.firstIndex(of: dartImageName) else {
            return Defaults.dartImageNameIdx
        }
        
        return idx
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
