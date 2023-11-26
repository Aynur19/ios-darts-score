//
//  Dart.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

struct Dart: Identifiable {
    let id: String
    let position: CGPoint
    let sector: DartsSector
    
    init(for position: CGPoint, in sector: DartsSector) {
        self.id = UUID().uuidString
        self.position = position
        self.sector = sector
    }
    
    func globalPosition(center: CGPoint) -> CGPoint {
        .toGlobal(center: center, localPoint: position)
    }
}

extension Dart: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.position = try container.decode(CGPoint.self, forKey: .position)
        self.sector = try container.decode(DartsSector.self, forKey: .sector)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case position
        case sector
    }
}

//extension Dart: CustomStringConvertible {
//    var description: String {
//        "Dart:\n" +
//        "  position: \(position.toStr())\n" +
//        "  sector: \(sector)"
//    }
//}
