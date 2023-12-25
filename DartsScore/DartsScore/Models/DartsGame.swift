//
//  DartsGame.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

private let snapshotsJsonNamePrefix = "GameSnapshots_"

struct DartsGame: Identifiable {
    let id: String
    let attempts: Int
    let timeForAnswer: Int
    let missesIsEnabled: Bool
    let snapshotsJsonName: String
    
    private(set) var score: Int = .zero
    private(set) var spentAttempts: Int = .zero
    private(set) var correct: Int = .zero
    private(set) var skipped: Int = .zero
    private(set) var timeSpent: Int = .zero
    private(set) var dateTime: Date = .now
    
    init(
        _ id: String = UUID().uuidString,
        attempts: Int,
        timeForAnswer: Int,
        missesIsEnabled: Bool
    ) {
        self.id = id
        self.attempts = attempts
        self.timeForAnswer = timeForAnswer
        self.missesIsEnabled = missesIsEnabled
        self.snapshotsJsonName = snapshotsJsonNamePrefix + id
    }
    
    init(
        id: String = UUID().uuidString,
        attempts: Int,
        timeForAnswer: Int,
        missesIsEnabled: Bool,
        score: Int,
        successAttempts: Int,
        timeSpent: Int,
        dateTime: Date
    ) {
        self.init(id, attempts: attempts, timeForAnswer: timeForAnswer, missesIsEnabled: missesIsEnabled)
        self.score = score
        self.correct = successAttempts
        self.timeSpent = timeSpent
        self.dateTime = dateTime
    }
    
    mutating func onMissed(for time: Int) {
        skipped += 1
        timeSpent += time
        
        spentAttempts += 1
    }
    
    mutating func onAnswered(score: Int, for time: Int) {
        self.score += score
        timeSpent += time
        
        if score > .zero {
            correct += 1
        }
        
        spentAttempts += 1
    }
    
    mutating func onFinished() {
        dateTime = .now
    }
    
    var isGoodGame: Bool {
        correct >= spentAttempts - correct
    }
    
    var misses: Int {
        spentAttempts - correct - skipped
    }
}

extension DartsGame: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id                 = try container.decode(String.self, forKey: .id)
        self.attempts           = try container.decode(Int.self, forKey: .attempts)
        self.timeForAnswer      = try container.decode(Int.self, forKey: .timeForAnswer)
        self.missesIsEnabled    = try container.decode(Bool.self, forKey: .missesIsEnabled)
        self.snapshotsJsonName  = try container.decode(String.self, forKey: .snapshotsJsonName)
        self.score              = try container.decode(Int.self, forKey: .score)
        self.spentAttempts      = try container.decode(Int.self, forKey: .spentAttempts)
        self.correct            = try container.decode(Int.self, forKey: .correct)
        self.skipped            = try container.decode(Int.self, forKey: .skipped)
        self.timeSpent          = try container.decode(Int.self, forKey: .timeSpent)
        
        let dateDecodingStrategy = ISO8601DateFormatter()
        self.dateTime = try dateDecodingStrategy.date(from: container.decode(String.self, forKey: .dateTime)) ?? .now
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attempts
        case timeForAnswer
        case missesIsEnabled
        case snapshotsJsonName
        case score
        case spentAttempts
        case correct
        case skipped
        case timeSpent
        case dateTime
    }
}
