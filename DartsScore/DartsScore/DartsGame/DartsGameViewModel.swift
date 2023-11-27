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
    
    private let appSettings: AppSettings
    private var attempts: Int = .zero
    
    @Published private(set) var game: DartsGame
    @Published private(set) var snapshots: DartsGameSnapshotsList
    
    @Published private(set) var state: GameState = .idle
    @Published private(set) var currentAnswers = [Int]()
    
    init(appSettings: AppSettings = .shared) {
        self.appSettings = appSettings
        let gameId = UUID().uuidString
        
        self.game = .init(gameId, attempts: appSettings.attempts, timeForAnswer: appSettings.timeForAnswer)
        self.snapshots = .init(gameId)
    }
    
    var remainingAttempts: Int {
        game.attempts - attempts
    }

    func reset(isRestart: Bool = false) {
        if !isRestart {
            game = JsonCache.loadGame(from: AppSettings.gameJsonFileName)
            snapshots = JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
//            loadGameStats(from: game.statsJsonName, gameId: game.id)
        } else {
            restart()
        }
        
        attempts = game.spentAttempts
        state = attempts == .zero ? .idle : .stoped
    }
    
    func restart() {
        JsonCache.deleteFile(name: AppSettings.gameJsonFileName)
        game = .init(attempts: appSettings.attempts, timeForAnswer: appSettings.timeForAnswer)
        snapshots = .init(game.id)
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
        
        while generatedAnswers.count < AppSettings.answersCount {
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
            let scoreMultiplier = CGFloat(AppSettings.standardTimeForAnswer / game.timeForAnswer)
            return Int(CGFloat(game.timeForAnswer) / CGFloat(time) * scoreMultiplier)
        }
        
        return .zero
    }
    
//    func onAnswered(_ answer: Int, expectedScore: Int, time: Int, darts: [Dart]) {
//        model.answer(
//            from: currentAnswers,
//            for: time,
//            expected: expectedScore,
//            actual: answer,
//            darts: darts
//        )
//        
//        attempts += 1
//        
//        if model.attempts == attempts {
//            state = .finished
//            gameOver()
//        }
//    }
    
    func stop() {
        if state == .processing {
            JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
            JsonCache.saveGame(game, to: AppSettings.gameJsonFileName)
//            saveGameStats(to: game.id)
//            saveGame()
        }
    }
    
    func gameOver() {
//        JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
        
        var context = JsonCache.loadDartsGameStats(from: AppSettings.statsJsonFileName)
        
        if context.add(game) {
            JsonCache.saveGameSnapshotsList(snapshots, to: game.snapshotsJsonName)
            JsonCache.saveDartsGameStats(context, to: AppSettings.statsJsonFileName)
        }
        
        JsonCache.deleteFile(name: AppSettings.gameJsonFileName)
    }
}

// Save and load
//extension DartsGameViewModel {
//    private func loadGame() {
//        let jsonName = AppSettings.gameJsonFileName
//        game = (try? JsonCache<DartsGame>.load(from: jsonName))
//                ?? .init(attempts: appSettings.attempts, timeForAnswer: appSettings.timeForAnswer)
//    }
//    
//    private func saveGame() {
//        do {
//            let jsonName = AppSettings.gameJsonFileName
//            try JsonCache<DartsGame>.save(game, to: jsonName)
//            
//            print("Saved Game!")
//        } catch {
//            print("*******************************************************")
//            print(#function)
//            print(error.localizedDescription)
//            print("*******************************************************")
//        }
//    }
//    
//    private func loadGameStats(from jsonName: String, gameId: String) {
//        snapshots = (try? JsonCache<DartsGameSnaphotsList>.load(from: jsonName)) ?? .init(gameId)
////        
////        snapshots.removeAll()
////        
////        if let loadedSnapshots = try? JsonCache<[DartsGameSnapshot]>.load(from: jsonName) {
////            snapshots.append(contentsOf: loadedSnapshots)
////        }
//    }
//    
//    private func saveGameStats(to jsonName: String) {
//        do {
//            try JsonCache<DartsGameSnaphotsList>.save(snapshots, to: jsonName)
//            
//            print("Saved Game Snapshots!")
//        } catch {
//            print("*******************************************************")
//            print(#function)
//            print(error.localizedDescription)
//            print("*******************************************************")
//        }
//    }
//
//    private func loadDartsGameHistory() -> DartsGameStats {
//        let jsonName = AppSettings.historyJsonFileName
//        return (try? JsonCache<DartsGameStats>.load(from: jsonName)) ?? .init()
//    }
//    
//    private func saveDartsGameHistory() {
//        do {
//            var context = loadDartsGameHistory()
//            
//            context.add(game)
//            try JsonCache<DartsGameStats>.save(context, to: AppSettings.historyJsonFileName)
//            JsonCache<DartsGame>.deleteFile(name: AppSettings.gameJsonFileName)
//            
//            print("Saved Game Stats!")
//        } catch {
//            print("*******************************************************")
//            print(#function)
//            print(error.localizedDescription)
//            print("*******************************************************")
//        }
//    }
//}
