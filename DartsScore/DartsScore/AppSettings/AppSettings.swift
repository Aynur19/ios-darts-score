//
//  AppSettings.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 13.12.2023.
//

import Foundation

struct AppSettings {
    private typealias Constants = AppConstants
    
    private enum AppSettingsKeys: String {
        case attempts
        case timeForAnswer
        case dartsWithMiss
        
        case dartImageName
        case dartSize
        case dartColor
        
        case dartsTargetPalette
    }

    private let defaults = UserDefaults.standard
    
    let attempts: Int
    let timeForAnswer: Int
    let dartsWithMiss: Bool
    let dartImageName: DartImageName
    let dartSize: Int
    let dartsTargetPalette: DartsTargetPalette
    
    init() {
        print("AppSettings.\(#function)")
        
        Self.registerSettings()
        
        attempts            = defaults.integer(forKey: AppSettingsKeys.attempts.rawValue)
        timeForAnswer       = defaults.integer(forKey: AppSettingsKeys.timeForAnswer.rawValue)
        dartsWithMiss       = defaults.bool(forKey: AppSettingsKeys.dartsWithMiss.rawValue)
        dartImageName       = Self.loadDartImageName()
        dartSize            = defaults.integer(forKey: AppSettingsKeys.dartSize.rawValue)
        dartsTargetPalette  = Self.loadDartsTargetPalette()
    }
    
    init(
        attempts: Int,
        timeForAnswer: Int,
        dartsWithMiss: Bool,
        dartImageName: DartImageName,
        dartSize: Int,
        dartsTargetPalette: DartsTargetPalette
    ) {
        print("AppSettings.\(#function)")
        
        self.attempts = attempts
        self.timeForAnswer = timeForAnswer
        self.dartsWithMiss = dartsWithMiss
        self.dartImageName = dartImageName
        self.dartSize = dartSize
        self.dartsTargetPalette = dartsTargetPalette
    }
    
    func save() {
        print("  AppSettings.\(#function)")
        
        defaults.setValue(attempts, forKey: AppSettingsKeys.attempts.rawValue)
        defaults.setValue(timeForAnswer, forKey: AppSettingsKeys.timeForAnswer.rawValue)
        defaults.setValue(dartsWithMiss, forKey: AppSettingsKeys.dartsWithMiss.rawValue)
        defaults.setValue(dartImageName.rawValue, forKey: AppSettingsKeys.dartImageName.rawValue)
        defaults.setValue(dartSize, forKey: AppSettingsKeys.dartSize.rawValue)
        
        defaults.setValue(dartsTargetPalette.rawValue, forKey: AppSettingsKeys.dartsTargetPalette.rawValue)
    }
    
    private static func registerSettings() {
        print("  AppSettings.\(#function)")
        UserDefaults.standard.register(
            defaults: [
                AppSettingsKeys.attempts.rawValue: Constants.defaultAttempts,
                AppSettingsKeys.timeForAnswer.rawValue: Constants.defaultTimeForAnswer,
                AppSettingsKeys.dartsWithMiss.rawValue: Constants.defaultDartsWithMiss,
                AppSettingsKeys.dartImageName.rawValue: Constants.defaultDartImageName.rawValue,
                AppSettingsKeys.dartSize.rawValue: Constants.defaultDartSize,
                AppSettingsKeys.dartsTargetPalette.rawValue: Constants.defaultDartsTargetPalette.rawValue
            ]
        )
    }
    
    private static func saveColor(_ codableColor: CodableColor, key: String) {
        print("  AppSettings.\(#function)")
        if let encodedData = try? JSONEncoder().encode(codableColor) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }

    private static func loadColor(for key: String) -> CodableColor? {
        print("  AppSettings.\(#function)")
        guard let loadedData = UserDefaults.standard.data(forKey: key),
              let codableColor = try? JSONDecoder().decode(CodableColor.self, from: loadedData) else {
            return nil
        }
        
        return codableColor
    }
    
    private static func loadDartsTargetPalette() -> DartsTargetPalette {
        print("  AppSettings.\(#function)")
        guard let rawValue = UserDefaults.standard.string(forKey: AppSettingsKeys.dartsTargetPalette.rawValue) else {
            return Constants.defaultDartsTargetPalette
        }
        
        return .init(rawValue: rawValue) ?? Constants.defaultDartsTargetPalette
    }
    
    private static func loadDartImageName() -> DartImageName {
        print("  AppSettings.\(#function)")
        guard let rawValue = UserDefaults.standard.string(forKey: AppSettingsKeys.dartImageName.rawValue) else {
            return Constants.defaultDartImageName
        }
        
        return .init(rawValue: rawValue) ?? Constants.defaultDartImageName
    }
}
