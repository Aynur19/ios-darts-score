//
//  SettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 13.12.2023.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    private typealias Constants = AppSettingsConstants
    
    @Published private(set) var isChanged: Bool = false
    @Published private(set) var isDefaults: Bool = false
    
    @Published var attempts: Int { didSet { checkChangesAndDefaults() } }
    
    @Published var timeForAnswerIdx: Int { didSet { updateTimeForAnswer() } }
    @Published private(set) var timeForAnswer: Int
    
    @Published var dartsWithMiss: Bool { didSet { updateDarts() } }
    @Published private(set) var darts: [Dart]
    
    @Published var dartImageNameIdx: Int { didSet { updateDartImageName() } }
    @Published private(set) var dartImageName: DartImageName
    
    @Published var dartSize: Int { didSet { checkChangesAndDefaults() } }
    
    private let appSettings: AppSettings
    private let snapshots = MockData.getDartsGameSnapshotsList().snapshots
    
    init(appSettings: AppSettings) {
        print("SettingsViewModel.\(#function)")
        
        self.attempts = appSettings.attempts
        
        self.timeForAnswerIdx = Self.getTimeForAnswerIdx(appSettings.timeForAnswer)
        self.timeForAnswer = appSettings.timeForAnswer.msToSec
        
        self.dartsWithMiss = appSettings.dartsWithMiss
        self.darts = appSettings.dartsWithMiss ? snapshots[0].darts : snapshots[1].darts
        
        self.dartImageNameIdx = Self.getDartImageNameIdx(appSettings.dartImageName)
        self.dartImageName = appSettings.dartImageName
        
        self.dartSize = appSettings.dartSize
        self.appSettings = appSettings
        
        checkChangesAndDefaults()
    }
    
    private static func getTimeForAnswerIdx(_ timeForAnswer: Int) -> Int {
        Constants.timesForAnswerData.firstIndex(of: timeForAnswer.msToSec) ?? Constants.defaultTimeForAnswerIdx
    }
    
    private static func getDartImageNameIdx(_ dartImageName: DartImageName) -> Int {
        Constants.dartImageNamesData.firstIndex(of: dartImageName) ?? Constants.defaultDartImageNameIdx
    }
    
    func checkChangesAndDefaults() {
        checkChanges()
        checkDefaults()
    }
    
    func checkChanges() {
        isChanged = appSettings.attempts != attempts
        || appSettings.timeForAnswer.msToSec != timeForAnswer
        || appSettings.dartsWithMiss != dartsWithMiss
        || appSettings.dartImageName != dartImageName
        || appSettings.dartSize != dartSize
    }
    
    func checkDefaults() {
        isDefaults = attempts == Constants.defaultAttempts
        && timeForAnswer == Constants.defaultTimeForAnswer
        && dartsWithMiss == Constants.defaultDartsWithMiss
        && dartImageName == Constants.defaultDartImageName
        && dartSize == Constants.defaultDartSize
    }
    
    func reset() {
        attempts = Constants.defaultAttempts
        timeForAnswerIdx = Constants.defaultTimeForAnswerIdx
//        self.timeForAnswer = appSettings.timeForAnswer.msToSec
        
        dartsWithMiss = Constants.defaultDartsWithMiss
//        self.darts = appSettings.dartsWithMiss ? snapshots[0].darts : snapshots[1].darts
        
        dartImageNameIdx = Constants.defaultDartImageNameIdx// Self.getDartImageNameIdx(appSettings)
//        self.dartImageName = appSettings.dartImageName
        
        dartSize = Constants.defaultDartSize// appSettings.dartSize
    }
    
    private func updateDarts() {
        darts = dartsWithMiss ? snapshots[0].darts : snapshots[1].darts
        checkChangesAndDefaults()
    }
    
    private func updateTimeForAnswer() {
        timeForAnswer = Constants.timesForAnswerData[timeForAnswerIdx]
        checkChangesAndDefaults()
    }
    
    private func updateDartImageName() {
        dartImageName = Constants.dartImageNamesData[dartImageNameIdx]
        checkChangesAndDefaults()
    }
}
