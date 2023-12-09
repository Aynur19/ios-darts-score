//
//  DartsGameStats.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

struct DartsGameStats: Identifiable {
    let id: String
    let createdOn: Date
    private(set) var updatedOn: Date
    private(set) var items: [DartsGame]
    
    init(
        _ id: String = UUID().uuidString,
        createdOn: Date = .now,
        updatedOn: Date = .now,
        items: [DartsGame] = []
    ) {
        self.id = id
        self.createdOn = createdOn
        self.updatedOn = updatedOn
        self.items = items
    }
    
    mutating func add(_ item: DartsGame) -> Bool {
        var isAdded = true
        if items.count < AppConstants.statsMaxCount {
            items.append(item)
        } else {
            items.sort { $0.score > $1.score }
            
            if let score = items.last?.score, score < item.score {
                items[items.count - 1] = item
                items.sort { $0.score > $1.score }
                updatedOn = .now
            } else {
                isAdded = false
            }
        }
        
        return isAdded
    }
}

extension DartsGameStats: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id     = try container.decode(String.self, forKey: .id)
        self.items  = try container.decode([DartsGame].self, forKey: .items)

        let dateDecodingStrategy = ISO8601DateFormatter()
        self.createdOn = (try? dateDecodingStrategy
            .date(from: container.decode(String.self, forKey: .createdOn))) ?? .now
        self.updatedOn = (try? dateDecodingStrategy
            .date(from: container.decode(String.self, forKey: .updatedOn))) ?? .now
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case createdOn
        case updatedOn
        case items
    }
}
