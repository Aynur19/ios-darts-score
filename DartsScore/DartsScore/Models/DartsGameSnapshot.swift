//
//  DartsGameSnapshot.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

struct DartsGameSnapshot: Identifiable {
    let id: String
    let expected: Int
    let actual: Int
    let answers: [Int]
    let darts: [Dart]
    let time: Int
    let score: Int
    
    init(
        expected: Int,
        actual: Int,
        answers: [Int],
        darts: [Dart],
        time: Int,
        score: Int
    ) {
        self.id = UUID().uuidString
        self.expected = expected
        self.actual = actual
        self.answers = answers
        self.darts = darts
        self.time = time
        self.score = score
    }
}

extension DartsGameSnapshot: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.expected = try container.decode(Int.self, forKey: .expected)
        self.actual = try container.decode(Int.self, forKey: .actual)
        self.answers = try container.decode([Int].self, forKey: .answers)
        self.darts = try container.decode([Dart].self, forKey: .darts)
        self.time = try container.decode(Int.self, forKey: .time)
        self.score = try container.decode(Int.self, forKey: .score)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case expected
        case actual
        case answers
        case darts
        case time
        case score
    }
}
