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
    
    private let appSettings: AppSettings = .shared
    private var attempts: Int = .zero
    
    @Published private(set) var model: DartsGame = .init()
    @Published private(set) var state: GameState = .idle
    @Published private(set) var currentAnswers = [Int]()
    
    var remainingAttempts: Int {
        model.attempts - attempts
    }

    func reset(isRestart: Bool = false) {
        if !isRestart {
            let loadedModel = try? JsonCache<DartsGame>.load(from: AppSettings.gameJsonFileName)
            model = loadedModel ?? .init(attempts: appSettings.attempts, timeForAnswer: appSettings.timeForAnswer)
        } else {
            JsonCache<DartsGame>.deleteFile(name: AppSettings.gameJsonFileName)
            model = .init(attempts: appSettings.attempts, timeForAnswer: appSettings.timeForAnswer)
        }
        
        attempts = model.answers.count
        state = attempts == .zero ? .idle : .stoped
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
    
    func onAnswered(_ answer: Int, expectedScore: Int, time: Int, darts: [Dart]) {
        model.answer(
            from: currentAnswers,
            for: time,
            expected: expectedScore,
            actual: answer,
            darts: darts
        )
        
        attempts += 1
        
        if model.attempts == attempts {
            state = .finished
            gameOver()
        }
    }
    
    func stop() {
        if state == .processing {
            saveGame()
        }
    }
    
    func gameOver() {
        saveGameToStats()
    }
    
    private func saveGameToStats() {
        do {
            let jsonName = AppSettings.statsJsonFileName
            var context = (try? JsonCache<DartsGameStats>.load(from: jsonName)) ?? .init()
            
            context.add(model)
            try JsonCache<DartsGameStats>.save(context, to: jsonName)
            JsonCache<DartsGameStats>.deleteFile(name: AppSettings.gameJsonFileName)
        } catch {
            print("*******************************************************")
            print(#function)
            print(error.localizedDescription)
            print("*******************************************************")
        }
    }
    
    private func saveGame() {
        do {
            let jsonName = AppSettings.gameJsonFileName
            try JsonCache<DartsGame>.save(model, to: jsonName)
        } catch {
            print("*******************************************************")
            print(#function)
            print(error.localizedDescription)
            print("*******************************************************")
        }
    }
}
