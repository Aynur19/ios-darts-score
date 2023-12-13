//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

final class AppSettingsViewModel: ObservableObject {
    private typealias Constants = AppSettingsConstants
    
    @Published private(set) var model: AppSettings
    
    init() {
        print("AppSettingsViewModel.\(#function)")
        model = .init()
    }
    
    func save(settingsVM: SettingsViewModel) {
        model = AppSettings(
            attempts: settingsVM.attempts,
            timeForAnswer: settingsVM.timeForAnswer.secToMs,
            dartsWithMiss: settingsVM.dartsWithMiss,
            dartImageName: settingsVM.dartImageName,
            dartSize: settingsVM.dartSize,
            dartsTargetPalette: .classic
        )
        
        model.save()
    }
}

final class SettingsViewModel: ObservableObject {
    private typealias Constants = AppSettingsConstants
    
    @Published private(set) var isChanged: Bool = false
    
    @Published var attempts: Int {
        didSet { checkChanges() }
    }
    
    @Published var timeForAnswerIdx: Int {
        didSet {
            updateTimeForAnswer()
            checkChanges()
        }
    }
    @Published private(set) var timeForAnswer: Int
    
    @Published var dartsWithMiss: Bool {
        didSet { 
            updateDarts()
            checkChanges()
        }
    }
    @Published private(set) var darts: [Dart]
    
    @Published var dartImageNameIdx: Int {
        didSet {
            updateDartImageName()
            checkChanges()
        }
    }
    @Published private(set) var dartImageName: DartImage
    
    @Published var dartSize: Int {
        didSet { checkChanges() }
    }
    
    private let appSettings: AppSettings
    private let snapshots = MockData.getDartsGameSnapshotsList().snapshots
    
    init(appSettings: AppSettings) {
        print("SettingsViewModel.\(#function)")
        self.appSettings = appSettings
        self.attempts = appSettings.attempts
        
        self.timeForAnswerIdx = Self.getTimeForAnswerIdx(appSettings)
        self.timeForAnswer = appSettings.timeForAnswer.msToSec
        
        self.dartsWithMiss = appSettings.dartsWithMiss
        
        self.dartImageNameIdx = Self.getDartImageNameIdx(appSettings)
        self.dartImageName = appSettings.dartImageName
        
        self.dartSize = appSettings.dartSize
        
        self.darts = appSettings.dartsWithMiss ? snapshots[0].darts : snapshots[1].darts
    }
    
    private static func getTimeForAnswerIdx(_ appSettings: AppSettings) -> Int {
        Constants.timesForAnswerData.firstIndex(of: appSettings.timeForAnswer.msToSec) ?? Constants.defaultTimeForAnswerIdx
    }
    
    private static func getDartImageNameIdx(_ appSettings: AppSettings) -> Int {
        Constants.dartImageNamesData.firstIndex(of: appSettings.dartImageName) ?? Constants.defaultDartImageNameIdx
    }
    
    func checkChanges() {
        isChanged = appSettings.attempts != attempts
        || appSettings.timeForAnswer.msToSec != timeForAnswer
        || appSettings.dartsWithMiss != dartsWithMiss
        || appSettings.dartImageName != dartImageName
        || appSettings.dartSize != dartSize
    }
    
    private func updateDarts() {
        darts = dartsWithMiss ? snapshots[0].darts : snapshots[1].darts
    }
    
    private func updateTimeForAnswer() {
        timeForAnswer = Constants.timesForAnswerData[timeForAnswerIdx]
    }
    
    private func updateDartImageName() {
        dartImageName = Constants.dartImageNamesData[dartImageNameIdx]
    }
}
