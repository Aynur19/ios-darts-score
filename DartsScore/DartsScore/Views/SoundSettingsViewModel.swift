////
////  SoundSettingsViewModel.swift
////  DartsScore
////
////  Created by Aynur Nasybullin on 18.12.2023.
////
//
//import Foundation
//
//final class SoundSettingsViewModel: ObservableObject {
//    private typealias Constants = AppConstants
//    
//    @Published private(set) var isChanged: Bool = false
//    
//    @Published var tapSoundIsEnabled: Bool
//    @Published var tapSoundVolume: Float
//    
//    @Published var timerEndSoundIsEnabled: Bool
//    @Published var timerEndSoundVolume: Float
//    
//    @Published var targetRotationSoundIsEnabled: Bool
//    @Published var targetRotationSoundVolume: Float
//    
//    @Published var gameResultSoundIsEnabled: Bool
//    @Published var gameGoodResultSoundVolume: Float
//    @Published var gameBadResultSoundVolume: Float
//    
//    private let settings: AppSoundSettings
//    
//    init(settings: AppSoundSettings) {
//        self.tapSoundIsEnabled  = settings.tapSoundIsEnabled
//        self.tapSoundVolume     = settings.tapSoundVolume
//        
//        self.timerEndSoundIsEnabled = settings.timerEndSoundIsEnabled
//        self.timerEndSoundVolume    = settings.timerEndSoundVolume
//        
//        self.targetRotationSoundIsEnabled   = settings.targetRotationSoundIsEnabled
//        self.targetRotationSoundVolume      = settings.targetRotationSoundVolume
//        
//        self.gameResultSoundIsEnabled   = settings.gameResultSoundIsEnabled
//        self.gameGoodResultSoundVolume  = settings.gameGoodResultSoundVolume
//        self.gameBadResultSoundVolume   = settings.gameBadResultSoundVolume
//        
//        self.settings = settings
//        
//        checkChanges()
//    }
//    
//    func checkChanges() {
//        isChanged 
//        = settings.tapSoundIsEnabled != tapSoundIsEnabled
//        || settings.tapSoundVolume != timeForAnswer
//        || settings.timerEndSoundIsEnabled != dartsWithMiss
//        || settings.timerEndSoundVolume != dartImageName
//        || settings.targetRotationSoundIsEnabled != dartSize
//        || settings.targetRotationSoundVolume
//        || settings.gameResultSoundIsEnabled
//        || settings.gameGoodResultSoundVolume
//        || settings.gameBadResultSoundVolume
//    }
//    
//    func cancel() {
//        attempts = appSettings.attempts
//        timeForAnswerIdx = Self.getTimeForAnswerIdx(appSettings.timeForAnswer)
//        dartsWithMiss = appSettings.dartsWithMiss
//        dartImageNameIdx = Self.getDartImageNameIdx(appSettings.dartImageName)
//        dartSize = appSettings.dartSize
//    }
//    
//    func reset() {
//        attempts = Constants.defaultAttempts
//        timeForAnswerIdx = Constants.defaultTimeForAnswerIdx
//        dartsWithMiss = Constants.defaultDartsWithMiss
//        dartImageNameIdx = Constants.defaultDartImageNameIdx
//        dartSize = Constants.defaultDartSize
//    }
//    
//    private func updateDarts() {
//        darts = dartsWithMiss ? snapshots[0].darts : snapshots[1].darts
//        checkChangesAndDefaults()
//    }
//    
//    private func updateTimeForAnswer() {
//        timeForAnswer = Constants.timesForAnswerData[timeForAnswerIdx]
//        checkChangesAndDefaults()
//    }
//    
//    private func updateDartImageName() {
//        dartImageName = Constants.dartImageNamesData[dartImageNameIdx]
//        checkChangesAndDefaults()
//    }
//}
