//
//  DartsGameStats.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

struct DartsGameHistory: Identifiable {
    let id: String
    let createdOn: Date
    var updatedOn: Date
    var items: [DartsGame]
    
    init(
        createdOn: Date = .now,
        updatedOn: Date = .now,
        items: [DartsGame] = []
    ) {
        self.id = UUID().uuidString
        self.createdOn = createdOn
        self.updatedOn = updatedOn
        self.items = items
    }
    
    mutating func add(_ item: DartsGame) {
        if items.count < AppSettings.statsMaxCount {
            items.append(item)
        } else {
            items.sort { $0.score > $1.score }
            items[items.count - 1] = item
        }
        
        items.sort { $0.score > $1.score }
    }
}

extension DartsGameHistory: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.items = try container.decode([DartsGame].self, forKey: .items)

        let dateDecodingStrategy = ISO8601DateFormatter()
        self.createdOn = (try? dateDecodingStrategy
            .date(from: container.decode(String.self, forKey: .createdOn))) ?? Date()
        self.updatedOn = (try? dateDecodingStrategy
            .date(from: container.decode(String.self, forKey: .updatedOn))) ?? Date()
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case createdOn
        case updatedOn
        case items
    }
}
