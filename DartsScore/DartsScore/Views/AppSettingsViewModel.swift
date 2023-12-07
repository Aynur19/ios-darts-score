//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import Foundation

struct AppSettings {
    static let standardTimeForAnswer = 60.secToMs
    static let statsMaxCount = 50
    static let wireRadiusesCount = 6
    
    static let statsJsonFileName = "DartsGameStats"
    static let gameJsonFileName = "DartsGame"
    static let answersCount = 5
    
    static let attemptsCountData = [5, 10, 15, 20]
    static let defaultAttempts = attemptsCountData[1]
    
    static let timesForAnswerData = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    static let defaultTimeForAnserIdx = timesForAnswerData.count - 1
    static let defaultTimeForAnswer = timesForAnswerData[defaultTimeForAnserIdx]
    
    private(set) var dartsFrameWidth: CGFloat = 350 // 512
    private(set) var dartsCount = 3
    
//    private(set) var timeForAnswer = 60
}

final class AppSettingsViewModel: ObservableObject {
    enum AppSettingsKeys: String {
        case settingsIsInitialized
        case attemptsCount
        case timeForAnswerIdx
    }
    
    private(set) var settingsIsInitialized = false
    
    @Published private(set) var isChanged = false
    
    private var savedAttempts: Int// = AppSettings.defaultAttempts
    @Published var attempts: Int { didSet { checkChanges() } }
    
    @Published var timeForAnswerIdx: Int { didSet { checkChanges() } }
    @Published private(set) var timeForAnswer: Int/// = AppSettings.defaultTimeForAnswer
    
    init() {
        print("\n==========================================")
        print("AppSettingsViewModel.\(#function)")
        
        settingsIsInitialized = UserDefaults.standard.bool(forKey: AppSettingsKeys.settingsIsInitialized.rawValue)
        
        let attempts = Self.getAttempts(settingsIsInitialized)
        self.attempts = attempts
        self.savedAttempts = attempts
        
        let timeForAnswerIdx = Self.getTimeForAnswerIdx(settingsIsInitialized)
        self.timeForAnswerIdx = timeForAnswerIdx
        self.timeForAnswer = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs
        
        settingsIsInitialized = true
        
//        print("  AppSettingsViewModel:")
//        print("    savedAttempts: \(savedAttempts)")
//        print("    timeForAnswer: \(timeForAnswer)")
        
        checkChanges()
    }
    
    func resetSettings() {
        settingsIsInitialized = UserDefaults.standard.bool(forKey: AppSettingsKeys.settingsIsInitialized.rawValue)
        
        let attempts = Self.getAttempts(settingsIsInitialized)
        self.attempts = attempts
        self.savedAttempts = attempts
        
        let timeForAnswerIdx = Self.getTimeForAnswerIdx(settingsIsInitialized)
        self.timeForAnswerIdx = timeForAnswerIdx
        self.timeForAnswer = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs
        
        checkChanges()
    }
    
    func saveSettings() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(attempts, forKey: AppSettingsKeys.attemptsCount.rawValue)
        userDefaults.setValue(timeForAnswerIdx, forKey: AppSettingsKeys.timeForAnswerIdx.rawValue)
        userDefaults.setValue(settingsIsInitialized, forKey: AppSettingsKeys.settingsIsInitialized.rawValue)
        
        savedAttempts = attempts
        timeForAnswer = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs
        
        checkChanges()
    }
    
    func checkChanges() {
        print("AppSettingsViewModel.\(#function)")
//        print("  attempts: \(attempts)")
//        print("  savedAttempts: \(savedAttempts)")
//        print("  timeForAnswer: \(AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs)")
//        print("  timeForAnswer2: \(timeForAnswer)")
//        print("  timeForAnswerIdx: \(timeForAnswerIdx)")
        
        isChanged = attemptsIsChanged
                    || timeForAnswerIsChanged
    }
    
    private static func getAttempts(_ isInitialized: Bool = true) -> Int {
        if isInitialized {
            return UserDefaults.standard.integer(forKey: AppSettingsKeys.attemptsCount.rawValue)
        }
        
        return AppSettings.defaultAttempts
    }
    
    private static func getTimeForAnswerIdx(_ isInitialized: Bool = true) -> Int {
        if isInitialized {
            return UserDefaults.standard.integer(forKey: AppSettingsKeys.timeForAnswerIdx.rawValue)
        }
        
        return AppSettings.defaultTimeForAnserIdx
    }
    
    private var timeForAnswerIsChanged: Bool {
        AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs != timeForAnswer
//        let isChanged = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs != timeForAnswer
//        print("  timeForAnswerIsChanged: \(isChanged)")
//        return isChanged
    }
    
    private var attemptsIsChanged: Bool {
        savedAttempts != attempts
//        let isChanged = savedAttempts != attempts
//        print("  attemptsIsChanged: \(isChanged)")
//        return isChanged
    }
}
