//
//  DartsGameViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

final class DartsGameViewModel: ObservableObject {
    enum GameState {
        case idle
        case processing
        case stoped
        case finished
    }
    
//    private(set) var attempts: Int
    private(set) var appSettings: AppSettings
//    private(set) var timeForAnswer: Int
//    private(set) var dartsWithMiss: Bool
    
    @Published private(set) var game: DartsGame
    @Published private(set) var snapshots: DartsGameSnapshotsList
    
    @Published private(set) var state: GameState = .idle
    @Published private(set) var currentAnswers = [Int]()
    
    init(_ appSettings: AppSettings) {
        print("DartsGameViewModel.\(#function)")
        self.appSettings = appSettings
//        let gameId = UUID().uuidString
        
        let game = Self.loadGame(appSettings: appSettings)
        self.game = game
        self.snapshots = .init(game.id)
//        self.attempts = game.attempts
    }
    
    private static func loadGame(appSettings: AppSettings) -> DartsGame {
        JsonCache.loadGame(from: AppConstants.gameJsonName)
        ?? .init(attempts: appSettings.attempts,
                 timeForAnswer: appSettings.timeForAnswer,
                 dartsWithMiss: appSettings.dartsWithMiss)
    }
    
    var remainingAttempts: Int {
        game.attempts - game.spentAttempts
    }

    func reset() {
        game = Self.loadGame(appSettings: appSettings)
        snapshots = JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
        
//        attempts = game.attempts
//        timeForAnswer = game.timeForAnswer
        state = game.spentAttempts == .zero ? .idle : .stoped
    }
    
    func restart(appSettings: AppSettings) {
        self.appSettings = appSettings
        JsonCache.deleteFile(name: AppConstants.gameJsonName)
        game = .init(attempts: appSettings.attempts,
                     timeForAnswer: appSettings.timeForAnswer,
                     dartsWithMiss: appSettings.dartsWithMiss)
        snapshots = .init(game.id)
        
//        self.attempts = game.attempts
//        self.timeForAnswer = game.timeForAnswer
        state = .idle
    }
    
    func start() {
        state = .processing
    }
    
    func generateAnswers(_ expectedScore: Int) {
        currentAnswers.removeAll()
        currentAnswers.append(contentsOf: getAnswers(expectedScore))
    }
    
    private func getAnswers(_ expectedScore: Int) -> [Int] {
        var generatedAnswers = [expectedScore]
        
        while generatedAnswers.count < AppConstants.answersCount {
            let newScore = Int.random(in: 0...DartsConstants.maxScore)
            if !generatedAnswers.contains(newScore) {
                generatedAnswers.append(newScore)
            }
        }
        
        return generatedAnswers.shuffled()
    }
    
    func onAnswered(for time: Int, expected: Int, actual: Int, darts: [Dart]) {
        let timeForCurrentAnswer = game.timeForAnswer - time
        let scoreForCurrentAnswer = getScoreForAnswer(
            expected: expected,
            actual: actual,
            time: timeForCurrentAnswer
        )
        
        let answerSnapshot = DartsGameSnapshot(
            id: snapshots.snapshots.count,
            expected: expected,
            actual: actual,
            answers: currentAnswers,
            darts: darts,
            time: timeForCurrentAnswer,
            score: scoreForCurrentAnswer
        )
        
        snapshots.add(answerSnapshot)
        game.onAnswered(scoreForCurrentAnswer, for: timeForCurrentAnswer)
        
//        attempts += 1
        
        if game.attempts == game.spentAttempts {
            state = .finished
            gameOver()
        }
    }
    
    private func getScoreForAnswer(expected: Int, actual: Int, time: Int) -> Int {
        if expected == actual {
            let scoreMultiplier = CGFloat(AppConstants.standardTimeForAnswer / game.timeForAnswer)
            return Int(CGFloat(game.timeForAnswer) / CGFloat(time) * scoreMultiplier)
        }
        
        return .zero
    }
    
    func stop() {
        if state == .processing {
            JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
            JsonCache.saveGame(game, to: AppConstants.gameJsonName)
            
            state = .stoped
        }
    }
    
    func gameOver() {
        var context = JsonCache.loadDartsGameStats(from: AppConstants.statsJsonName)
        
        if context.add(game) {
            JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
            JsonCache.saveDartsGameStats(context, to: AppConstants.statsJsonName)
        }
        
        JsonCache.deleteFile(name: AppConstants.gameJsonName)
    }
}
