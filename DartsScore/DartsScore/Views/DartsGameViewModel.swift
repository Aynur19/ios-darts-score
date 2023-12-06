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
    
//    private let appSettings: AppSettingsVM
    private(set) var attempts: Int = .zero
    private(set) var timeForAnswer: Int = .zero
    
    @Published private(set) var game: DartsGame
    @Published private(set) var snapshots: DartsGameSnapshotsList
    
    @Published private(set) var state: GameState = .idle
    @Published private(set) var currentAnswers = [Int]()
    
    init(_ attempts: Int, _ timeForAnswer: Int) {
        let gameId = UUID().uuidString
        
        self.game = Self.loadGame(attempts, timeForAnswer)
        self.snapshots = .init(gameId)
        
        self.attempts = game.attempts
        self.timeForAnswer = game.timeForAnswer
    }
    
    private static func loadGame(_ attempts: Int, _ timeForAnswer: Int) -> DartsGame {
        JsonCache.loadGame(from: AppSettingsVM.gameJsonFileName) ?? .init(attempts: attempts, timeForAnswer: timeForAnswer)
    }
    
    var remainingAttempts: Int {
        game.attempts - game.spentAttempts
    }

    func reset() {
        game = Self.loadGame(attempts, timeForAnswer)
        snapshots = JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
        
        attempts = game.attempts
        timeForAnswer = game.timeForAnswer
        state = game.spentAttempts == .zero ? .idle : .stoped
    }
    
    func restart(_ attempts: Int, _ timeForAnswer: Int) {
        JsonCache.deleteFile(name: AppSettingsVM.gameJsonFileName)
        game = .init(attempts: attempts, timeForAnswer: timeForAnswer)
        snapshots = .init(game.id)
        
        self.attempts = game.attempts
        self.timeForAnswer = game.timeForAnswer
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
        
        while generatedAnswers.count < AppSettingsVM.answersCount {
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
        
        attempts += 1
        
        if game.attempts == attempts {
            state = .finished
            gameOver()
        }
    }
    
    private func getScoreForAnswer(expected: Int, actual: Int, time: Int) -> Int {
        if expected == actual {
            let scoreMultiplier = CGFloat(AppSettingsVM.standardTimeForAnswer / game.timeForAnswer)
            return Int(CGFloat(game.timeForAnswer) / CGFloat(time) * scoreMultiplier)
        }
        
        return .zero
    }
    
    func stop() {
        if state == .processing {
            JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
            JsonCache.saveGame(game, to: AppSettingsVM.gameJsonFileName)
            
            state = .stoped
        }
    }
    
    func gameOver() {
        var context = JsonCache.loadDartsGameStats(from: AppSettingsVM.statsJsonFileName)
        
        if context.add(game) {
            JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
            JsonCache.saveDartsGameStats(context, to: AppSettingsVM.statsJsonFileName)
        }
        
        JsonCache.deleteFile(name: AppSettingsVM.gameJsonFileName)
    }
}
