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
    
    @Published private(set) var game: DartsGame
    @Published private(set) var snapshots: DartsGameSnapshotsList
    
    @Published private(set) var state: GameState = .idle
    @Published private(set) var currentAnswers = [Int]()
    
    init(attempts: Int, timeForAnswer: Int, missesIsEnabled: Bool) {
        print("DartsGameViewModel.\(#function)")
        
        let game = Self.loadGame(
            attempts: attempts,
            timeForAnswer: timeForAnswer,
            missesIsEnabled: missesIsEnabled
        )
        self.game = game
        self.snapshots = .init(game.id)
    }
    
    private static func loadGame(attempts: Int, timeForAnswer: Int, missesIsEnabled: Bool) -> DartsGame {
        JsonCache.loadGame(from: AppConstants.gameJsonName)
        ?? .init(attempts: attempts,
                 timeForAnswer: timeForAnswer,
                 missesIsEnabled: missesIsEnabled)
    }
    
    var remainingAttempts: Int {
        game.attempts - game.spentAttempts
    }
    
    func reset(attempts: Int, timeForAnswer: Int, missesIsEnabled: Bool, isRestart: Bool = false) {
        if isRestart {
            restart(attempts: attempts, timeForAnswer: timeForAnswer, missesIsEnabled: missesIsEnabled)
            return
        }
            
        reset(attempts: attempts, timeForAnswer: timeForAnswer, missesIsEnabled: missesIsEnabled)
    }

    private func reset(attempts: Int, timeForAnswer: Int, missesIsEnabled: Bool) {
        game = Self.loadGame(
            attempts: attempts,
            timeForAnswer: timeForAnswer,
            missesIsEnabled: missesIsEnabled
        )
        snapshots = JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
    
        state = game.spentAttempts == .zero ? .idle : .stoped
    }
    
    private func restart(attempts: Int, timeForAnswer: Int, missesIsEnabled: Bool) {
        playTapSound()
        JsonCache.deleteFile(name: AppConstants.gameJsonName)
        game = .init(attempts: attempts,
                     timeForAnswer: timeForAnswer,
                     missesIsEnabled: missesIsEnabled)
        snapshots = .init(game.id)
        
        state = .idle
    }
    
    func start() {
        playTapSound()
        state = .processing
    }
    
    func generateAnswers(expectedScore: Int) {
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
    
    func onMissed(expected: Int, darts: [Dart]) {
        let answerSnapshot = DartsGameSnapshot(
            id: snapshots.snapshots.count,
            expected: expected,
            actual: -1,
            answers: currentAnswers,
            darts: darts,
            time: game.timeForAnswer,
            score: 0,
            isMissed: true
        )
        
        snapshots.add(answerSnapshot)
        game.onMissed(for: game.timeForAnswer)
        
        checkAttempts()
    }
    
    func onAnswered(for time: Int, expected: Int, actual: Int, darts: [Dart]) {
        playTapSound()
        
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
            score: scoreForCurrentAnswer,
            isMissed: false
        )
        
        snapshots.add(answerSnapshot)
        game.onAnswered(score: scoreForCurrentAnswer, for: timeForCurrentAnswer)
        
        checkAttempts()
    }
    
    private func checkAttempts() {
        if game.attempts == game.spentAttempts {
            gameOver()
            state = .finished
        }
    }
    
    private func getScoreForAnswer(expected: Int, actual: Int, time: Int) -> Int {
        if expected == actual {
            return AppDefaultSettings.getScoreForSuccesAnswer(
                timeForAnswer: game.timeForAnswer,
                time: time
            )
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
    
    func playResultSound() {
        Task { await MainActor.run { SoundManager.shared.play(resultSound) } }
    }
    
    func stopResultSound() {
        Task { await MainActor.run { SoundManager.shared.stop(resultSound) } }
    }
    
    private var isGoodReasult: Bool {
        game.correct >= game.attempts - game.correct
    }
    
    private var resultSound: SoundEnum {
        isGoodReasult ? .gameGoodResult : .gameBadResult
    }
    
    private func playTapSound() {
        Task { await MainActor.run { SoundManager.shared.play(.userTap) } }
    }
}
