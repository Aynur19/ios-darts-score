//
//  MockData.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 27.11.2023.
//

import Foundation

struct MockData {
    static func getDartsGameStats() -> DartsGameStats {
        .init(
            items: [
                .init(
                    id: "1",
                    attempts: 10,
                    timeForAnswer: 60.secToMs,
                    dartsWithMiss: true,
                    score: 218,
                    successAttempts: 4,
                    timeSpent: 67.secToMs,
                    dateTime: .now
                ),
                .init(
                    id: "2",
                    attempts: 10,
                    timeForAnswer: 60.secToMs,
                    dartsWithMiss: true,
                    score: 218,
                    successAttempts: 4,
                    timeSpent: 67.secToMs,
                    dateTime: .now
                )
            ]
        )
    }
    
    static func getDartsGameSnapshotsList() -> DartsGameSnapshotsList {
        .init(
            "1",
            snapshots: [
                .init(
                    id: 0,
                    expected: 46,
                    actual: 113,
                    answers: [100, 171, 113, 46, 131],
                    darts: [
                        .init(
                            for: .init(x: -74.68731142673033, y: 7.5668327770026425),
                            in: .init(10, points: 11, xScore: 3)
                        ),
                        .init(
                            for: .init(x: -114.41818603506827, y: -121.26699838960911),
                            in: .init(.outOfPoints)
                        ),
                        .init(
                            for: .init(x: 47.69048522948828, y: 10.236433758896286),
                            in: .init(1, points: 13, xScore: 1)
                        )
                    ],
                    time: 1100,
                    score: 0,
                    isMissed: false
                ),
                .init(
                    id: 1,
                    expected: 57,
                    actual: 57,
                    answers: [4, 27, 57, 166, 61],
                    darts: [
                        .init(
                            for: .init(x: -112.99518337758805, y: 49.58186017870711),
                            in: .init(9, points: 14, xScore: 2)
                        ),
                        .init(
                            for: .init(x: -54.74240928394898, y: -1.4117007953131555),
                            in: .init(10, points: 11, xScore: 1)
                        ),
                        .init(
                            for: .init(x: 25.090263003953215, y: 6.904254517419105),
                            in: .init(3, points: 18, xScore: 1)
                        )
                    ],
                    time: 1100,
                    score: 64,
                    isMissed: false
                )
            ]
        )
    }
}
