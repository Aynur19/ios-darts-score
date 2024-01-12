//
//  DartsConstants.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

enum DartsRadius {
    case x2
    case x3
    case baseBig
    case baseSmall
    case points25
    case bullEye
    case wire
}

struct DartsConstants {
    // MARK: Points
    static let points: [Int] = [6, 13, 4, 18, 1, 20, 5, 12, 9, 14, 11, 8, 16, 7, 19, 3, 17, 2, 15, 10]
    static let bullEyePoints = 50
    static let points25 = 25
    static let x1Score = 1
    static let x2Score = 2
    static let x3Score = 3
    static let maxScore = 180
    
    // MARK: Sizes
    static let targetRadius: CGFloat = 225              // Общий радиус
    static let xWidth: CGFloat = 8                      // Внутренняя ширина колец «даблов» и «треблов»
    
    static let bullEyeRadius: CGFloat = 12.7 / 2        // Внутренний диаметр «яблочка»
    static let centralCircleRadius: CGFloat = 31.8 / 2  // Внутренний диаметр внешнего центрального кольца
    static let x2Radius: CGFloat = 170                  // Расстояние от центра до внешней стороны кольца «даблов»
    static let x3Radius: CGFloat = 107                  // Расстояние от центра до внешней стороны кольца «треблов»
    static let wireThickness: CGFloat = 1.5             // Толщина проволоки
    static let wireRadius: CGFloat = 185                // Максимальный радиус проволки    
    static let circleWireRadiuses = 6
    
    static let symbolsDistanceCoef: CGFloat = 0.87
    static let rotationAngle = Angle.degrees(Double(360 / points.count / 2))
    static let dartsCount = 3
    
    static func getDartsTargetWidth(windowsSize: CGSize, hPadding: CGFloat = 24) -> CGFloat {
        windowsSize.width - hPadding.x2
    }
    
    static func getRadius(_ frameWidth: CGFloat, _ radiusType: DartsRadius) -> CGFloat {
        let resolution = frameWidth.half / targetRadius
        
        switch radiusType {
            case .x2:           return x2Radius * resolution
            case .baseBig:      return (x2Radius - xWidth.x2) * resolution
            case .x3:           return x3Radius * resolution
            case .baseSmall:    return (x3Radius - xWidth.x2) * resolution
            case .points25:     return centralCircleRadius * resolution
            case .bullEye:      return bullEyeRadius * resolution
            case .wire:         return wireRadius * resolution
        }
    }
    
    static func getWireLineWidth(_ frameWidth: CGFloat) -> CGFloat {
        frameWidth.half / DartsConstants.targetRadius * DartsConstants.wireThickness
    }
}
