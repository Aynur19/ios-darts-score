//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct AppSettings {
//    static let standardTimeForAnswer = 60.secToMs
//    static let statsMaxCount = 50
//    static let wireRadiusesCount = 6
    
//    static let statsJsonFileName = "DartsGameStats"
//    static let gameJsonFileName = "DartsGame"
//    static let answersCount = 5
    
    static let attemptsCountData = [5, 10, 15, 20]
    fileprivate static let defaultAttempts = attemptsCountData[1]
    
    static let timesForAnswerData = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    fileprivate static let defaultTimeForAnserIdx = timesForAnswerData.count - 1
    fileprivate static let defaultTimeForAnswer = timesForAnswerData[defaultTimeForAnserIdx]
    
    fileprivate static let defaultDartsWithMiss = true
    
    static let dartImageNamesData = [
        "xmark", "plus", "staroflife.fill"
    ]
    
    fileprivate static let defaultDartImageNameIdx = 0
    fileprivate static let defaultDartImageName = dartImageNamesData[defaultDartImageNameIdx]
    fileprivate static let defaultDartSize: CGFloat = 16
    fileprivate static let defaultDartColor: CodableColor = .init(.blue)
    
    fileprivate static let defaultDartsTargetPalette: DartsTargetPalette = .classic
    
//    private(set) var dartsFrameWidth: CGFloat = 350 // 512
//    private(set) var dartsCount = 3
    
    private enum AppSettingsKeys: String {
        case settingsIsInitialized
        case attempts
        case timeForAnswer
        
        case dartsWithMiss
        
        case dartImageName
        case dartSize
        case dartColor
        
        case dartsTargetPalette
    }
    
    private let defaults = UserDefaults.standard
    
    fileprivate(set) var attempts: Int
    fileprivate(set) var timeForAnswer: Int
    fileprivate(set) var dartsWithMiss: Bool
    
    fileprivate(set) var dartImageName: String
    fileprivate(set) var dartSize: CGFloat
    fileprivate(set) var dartColor: CodableColor
    
    fileprivate(set) var dartsTargetPalette: DartsTargetPalette
    
    init() {
        Self.registerSettings()
        
        attempts = defaults.integer(forKey: AppSettingsKeys.attempts.rawValue)
        timeForAnswer = defaults.integer(forKey: AppSettingsKeys.timeForAnswer.rawValue)
        dartsWithMiss = defaults.bool(forKey: AppSettingsKeys.dartsWithMiss.rawValue)
        dartImageName = defaults.string(forKey: AppSettingsKeys.dartImageName.rawValue) ?? Self.defaultDartImageName
        dartSize = CGFloat(defaults.double(forKey: AppSettingsKeys.dartSize.rawValue))
        
        dartColor = Self.loadColor(for: AppSettingsKeys.dartColor.rawValue) ?? Self.defaultDartColor
        dartsTargetPalette = Self.loadDartsTargetPalette(for: AppSettingsKeys.dartsTargetPalette.rawValue)
    }
    
    func save() {
        defaults.setValue(attempts, forKey: AppSettingsKeys.attempts.rawValue)
        defaults.setValue(timeForAnswer, forKey: AppSettingsKeys.timeForAnswer.rawValue)
        defaults.setValue(dartsWithMiss, forKey: AppSettingsKeys.dartsWithMiss.rawValue)
        defaults.setValue(dartImageName, forKey: AppSettingsKeys.dartImageName.rawValue)
        defaults.setValue(Double(dartSize), forKey: AppSettingsKeys.dartSize.rawValue)
        
        Self.saveColor(dartColor, key: AppSettingsKeys.dartColor.rawValue)
        defaults.setValue(dartsTargetPalette.rawValue, forKey: AppSettingsKeys.dartsTargetPalette.rawValue)
    }
    
    private static func registerSettings() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.register(
            defaults: [
                AppSettingsKeys.attempts.rawValue: Self.defaultAttempts,
                AppSettingsKeys.timeForAnswer.rawValue: Self.defaultTimeForAnswer,
                AppSettingsKeys.dartsWithMiss.rawValue: Self.defaultDartsWithMiss,
                AppSettingsKeys.dartImageName.rawValue: Self.defaultDartImageName,
                AppSettingsKeys.dartSize.rawValue: Double(Self.defaultDartSize)
            ]
        )
    }
    
    private static func saveColor(_ codableColor: CodableColor, key: String) {
        if let encodedData = try? JSONEncoder().encode(codableColor) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }

    private static func loadColor(for key: String) -> CodableColor? {
        guard let loadedData = UserDefaults.standard.data(forKey: key),
              let codableColor = try? JSONDecoder().decode(CodableColor.self, from: loadedData) else {
            return nil
        }
        
        return codableColor
    }
    
    private static func loadDartsTargetPalette(for key: String) -> DartsTargetPalette {
        guard let rawValue = UserDefaults.standard.string(forKey: AppSettingsKeys.dartsTargetPalette.rawValue) else {
            return Self.defaultDartsTargetPalette
        }
        
        return .init(rawValue: rawValue) ?? Self.defaultDartsTargetPalette
    }
}

final class AppSettingsViewModel: ObservableObject {
    private(set) var model: AppSettings
    
    private(set) var id: String
    
    @Published private(set) var isChanged = false
    
    @Published var attempts: Int {
        didSet { checkChanges() }
    }
    
    @Published var timeForAnswerIdx: Int {
        didSet { timeForAnswer = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs }
    }
    @Published private(set) var timeForAnswer: Int {
        didSet { checkChanges() }
    }
    
    @Published var dartsWithMiss: Bool {
        didSet { checkChanges() }
    }
    
    @Published var dartImageNameIdx: Int {
        didSet { dartImageName = AppSettings.dartImageNamesData[dartImageNameIdx] }
    }
    @Published private(set) var dartImageName: String {
        didSet { checkChanges() }
    }
    
    @Published var dartSize: CGFloat {
        didSet { checkChanges() }
    }
    
    @Published var dartColor: Color {
        didSet { dartCodableColor = .init(dartColor) }
    }
    private var dartCodableColor: CodableColor {
        didSet { checkChanges() }
    }
    
    @Published var dartsTargetPalette: DartsTargetPalette {
        didSet { checkChanges() }
    }
    
    init(_ model: AppSettings = .init()) {
        id = Date().description
        
        self.model = model
        
        attempts            = model.attempts
        timeForAnswerIdx    = Self.getTimeForAnswerIdx(model)
        timeForAnswer       = model.timeForAnswer
        dartsWithMiss       = model.dartsWithMiss
        
        dartImageNameIdx    = Self.getDartImageIdx(model)
        dartImageName       = model.dartImageName
        dartSize            = model.dartSize
        dartCodableColor    = model.dartColor
        dartColor           = model.dartColor.toColor()
        
        dartsTargetPalette  = model.dartsTargetPalette
    }
    
    func resetSettings() {
        id = Date().description
        
        attempts            = model.attempts
        timeForAnswerIdx    = Self.getTimeForAnswerIdx(model)
        timeForAnswer       = model.timeForAnswer
        dartsWithMiss       = model.dartsWithMiss
        
        dartImageNameIdx    = Self.getDartImageIdx(model)
        dartImageName       = model.dartImageName
        dartSize            = model.dartSize
        dartCodableColor    = model.dartColor
        dartColor           = model.dartColor.toColor()
        
        dartsTargetPalette  = model.dartsTargetPalette
        
        checkChanges()
    }
    
    func saveSettings() {
        model.attempts = attempts
        model.timeForAnswer = timeForAnswer
        model.dartsWithMiss = dartsWithMiss
        
        model.dartImageName = dartImageName
        model.dartSize      = dartSize
        model.dartColor     = dartCodableColor
        
        model.dartsTargetPalette = dartsTargetPalette
        
        model.save()
        checkChanges()
        
        id = Date().description
    }
    
    func checkChanges() {
        isChanged = attempts != model.attempts
        || timeForAnswer != model.timeForAnswer
        || dartsWithMiss != model.dartsWithMiss
        || dartImageName != model.dartImageName
        || dartCodableColor != model.dartColor
        || dartsTargetPalette != model.dartsTargetPalette
    }
    
    private static func getTimeForAnswerIdx(_ model: AppSettings) -> Int {
        guard let idx = AppSettings.timesForAnswerData.firstIndex(of: model.timeForAnswer) else {
            return AppSettings.defaultTimeForAnserIdx
        }
        
        return idx
    }
    
    private static func getDartImageIdx(_ model: AppSettings) -> Int {
        guard let idx = AppSettings.dartImageNamesData.firstIndex(of: model.dartImageName) else {
            return AppSettings.defaultDartImageNameIdx
        }
        
        return idx
    }
}
