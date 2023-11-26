//
//  DartsSector.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

enum DartsSectorArea: String, Codable {
    case points
    case wire
    case outOfPoints
    case bullEye
    case points25
}

struct DartsSector {
    let points: Int
    let xScore: Int
    let area: DartsSectorArea
    
    init(_ area: DartsSectorArea) {
        self.area = area

        switch area {
            case .bullEye:
                points = DartsConstants.bullEyePoints
                xScore = DartsConstants.x1Score
            case .points25:
                points = DartsConstants.points25
                xScore = DartsConstants.x1Score
            case .points:
                assertionFailure("Logic error!")
                points = .zero
                xScore = .zero
            default:
                points = .zero
                xScore = .zero
        }
    }
    
    init(points: Int, xScore: Int = DartsConstants.x1Score) {
        self.points = points
        self.xScore = xScore
        self.area = .points
    }
}

extension DartsSector: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.points = try container.decode(Int.self, forKey: .points)
        self.xScore = try container.decode(Int.self, forKey: .xScore)
        self.area = try container.decode(DartsSectorArea.self, forKey: .area)
    }

    private enum CodingKeys: String, CodingKey {
        case points
        case xScore
        case area
    }
}

//extension DartsSector: CustomStringConvertible {
//    var description: String {
//        switch area {
//            case .points:       return "\(points)x\(xScore)"
//            case .wire:         return "Wire"
//            case .outOfPoints:  return "Out of Points"
//            case .bullEye:      return "Bull Eye (50)"
//            case .points25:     return "25 Points"
//        }
//    }
//}
