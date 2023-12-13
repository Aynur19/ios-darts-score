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
    let dartsWithMiss: Bool
    let snapshotsJsonName: String
    
    private(set) var score: Int = .zero
    private(set) var spentAttempts: Int = .zero
    private(set) var successAttempts: Int = .zero
    private(set) var timeSpent: Int = .zero
    private(set) var dateTime: Date = .now
    
    init(
        _ id: String = UUID().uuidString,
        attempts: Int,
        timeForAnswer: Int,
        dartsWithMiss: Bool
    ) {
        self.id = id
        self.attempts = attempts
        self.timeForAnswer = timeForAnswer
        self.dartsWithMiss = dartsWithMiss
        self.snapshotsJsonName = snapshotsJsonNamePrefix + id
    }
    
    init(
        id: String = UUID().uuidString,
        attempts: Int,
        timeForAnswer: Int,
        dartsWithMiss: Bool,
        score: Int,
        successAttempts: Int,
        timeSpent: Int,
        dateTime: Date
    ) {
        self.init(id, attempts: attempts, timeForAnswer: timeForAnswer, dartsWithMiss: dartsWithMiss)
        self.score = score
        self.successAttempts = successAttempts
        self.timeSpent = timeSpent
        self.dateTime = dateTime
    }
    
    mutating func onAnswered(_ score: Int, for time: Int = .zero) {
        self.score += score
        timeSpent += time
        spentAttempts += 1
        
        if score > .zero {
            successAttempts += 1
        }
    }
    
    mutating func onFinished() {
        dateTime = .now
    }
}

extension DartsGame: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id                 = try container.decode(String.self, forKey: .id)
        self.attempts           = try container.decode(Int.self, forKey: .attempts)
        self.timeForAnswer      = try container.decode(Int.self, forKey: .timeForAnswer)
        self.dartsWithMiss      = try container.decode(Bool.self, forKey: .dartsWithMiss)
        self.snapshotsJsonName  = try container.decode(String.self, forKey: .snapshotsJsonName)
        self.score              = try container.decode(Int.self, forKey: .score)
        self.spentAttempts      = try container.decode(Int.self, forKey: .spentAttempts)
        self.successAttempts    = try container.decode(Int.self, forKey: .successAttempts)
        self.timeSpent          = try container.decode(Int.self, forKey: .timeSpent)
        
        let dateDecodingStrategy = ISO8601DateFormatter()
        self.dateTime = try dateDecodingStrategy.date(from: container.decode(String.self, forKey: .dateTime)) ?? .now
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case attempts
        case timeForAnswer
        case dartsWithMiss
        case snapshotsJsonName
        case score
        case spentAttempts
        case successAttempts
        case timeSpent
        case dateTime
    }
}
