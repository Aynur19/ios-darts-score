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
    static let timesForAnswerData = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    
    static let defaultTimeForAnswer = 60
    
    private(set) var dartsFrameWidth: CGFloat = 350 // 512
    private(set) var dartsCount = 3
    
//    private(set) var timeForAnswer = 60
}

final class AppSettingsViewModel: ObservableObject {
    enum AppSettingsKeys: String {
        case settingsIsInitialized
        case timeForAnswerIdx
    }
    
    private(set) var settingsIsInitialized = false
    
    @Published private(set) var isChanged = false
    
    @Published private(set) var attemptsCount = AppSettings.attemptsCountData[2]
    
    @Published var timeForAnswerIdx: Int = .zero
    @Published private(set) var timeForAnswer: Int = AppSettings.timesForAnswerData[0]
    
    init() {
        let userDefaults = UserDefaults.standard
        
        settingsIsInitialized = userDefaults.bool(forKey: AppSettingsKeys.settingsIsInitialized.rawValue)
        
        if settingsIsInitialized {
            timeForAnswerIdx = userDefaults.integer(forKey: AppSettingsKeys.timeForAnswerIdx.rawValue)
        } else {
            timeForAnswerIdx = AppSettings.timesForAnswerData.count - 1
        }
        
        timeForAnswer = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs
        settingsIsInitialized = true
        
        print("AppSettingsViewModel:")
        print("  timeForAnswer: \(timeForAnswer)")
    }
    
    func saveSettings() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(timeForAnswerIdx, forKey: AppSettingsKeys.timeForAnswerIdx.rawValue)
        userDefaults.setValue(settingsIsInitialized, forKey: AppSettingsKeys.settingsIsInitialized.rawValue)
        
        timeForAnswer = AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs
        
        checkChanges()
    }
    
    func checkChanges() {
        isChanged = checkTimeForAnswerIsChanged
    }
    
    private var checkTimeForAnswerIsChanged: Bool {
        AppSettings.timesForAnswerData[timeForAnswerIdx].secToMs != timeForAnswer
    }
}
