//
//  DartsGame.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

struct DartsGame: Identifiable {
    let id: String
    let attempts: Int
    let timeForAnswer: Int
    
    private(set) var dateTime: Date = .now
    private(set) var successCount: Int = .zero
    private(set) var score: Int = .zero
    private(set) var answers = [DartsGameSnapshot]()
    private(set) var remainingTimeForAnswer: Int = .zero
    
//    init() {
//        self.id = UUID().uuidString
//        self.attempts = .zero
//        self.timeForAnswer = .zero
//    }
    
    init(attempts: Int, timeForAnswer: Int) {
        self.id = UUID().uuidString
        self.attempts = attempts
        self.timeForAnswer = timeForAnswer
    }
    
    // TODO: for mock data
    init(
        attempts: Int,
        timeForAnswer: Int,
        successCount: Int,
        score: Int,
        answers: [DartsGameSnapshot],
        remainingTimeForAnswer: Int
    ) {
        self.id = UUID().uuidString
        self.attempts = attempts
        self.timeForAnswer = timeForAnswer
        self.successCount = successCount
        self.score = score
        self.answers = answers
        self.remainingTimeForAnswer = remainingTimeForAnswer
    }
    
    mutating func answer(
        from answers: [Int],
        for time: Int,
        expected: Int,
        actual: Int,
        darts: [Dart]
    ) {
        
        let timeForCurrentAnswer = timeForAnswer.secToMs - time
        let scoreForCurrentAnswer = getScoreForAnswer(
            expected: expected,
            actual: actual,
            time: timeForCurrentAnswer
        )
        
        let userAnswer = DartsGameSnapshot(
            expected: expected,
            actual: actual,
            answers: answers,
            darts: darts,
            time: timeForCurrentAnswer,
            score: scoreForCurrentAnswer
        )
        
        if actual == expected { successCount += 1 }
        
        dateTime = .now
        score += scoreForCurrentAnswer
        self.answers.append(userAnswer)
    }
    
    private func getScoreForAnswer(expected: Int, actual: Int, time: Int) -> Int {
        if expected == actual {
            let scoreMultiplier = CGFloat(AppSettings.standardTimeForAnswer / timeForAnswer)
            return Int(CGFloat(timeForAnswer.secToMs) / CGFloat(time) * scoreMultiplier)
        }
        
        return .zero
    }
}

extension DartsGame: Codable {
    init(from decoder: Decoder) throws {
        let dateDecodingStrategy = ISO8601DateFormatter()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.attempts = try container.decode(Int.self, forKey: .attempts)
        self.timeForAnswer = try container.decode(Int.self, forKey: .timeForAnswer)
        
        self.dateTime = try dateDecodingStrategy.date(from: container.decode(String.self, forKey: .dateTime)) ?? Date()
        self.successCount = try container.decode(Int.self, forKey: .successCount)
        self.score = try container.decode(Int.self, forKey: .score)
        self.answers = try container.decode([DartsGameSnapshot].self, forKey: .answers)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attempts
        case timeForAnswer
        case dateTime
        case successCount
        case score
        case answers
    }
}
