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
    /// Total target radius
    static let targetRadius: CGFloat = 225
    
    /// Internal width of double and treble rings.
    static let xWidth: CGFloat = 8
    
    /// Inner diameter of the bull's eye.
    static let bullEyeRadius: CGFloat = 12.7 / 2
    
    /// Inner diameter of outer center ring.
    static let centralCircleRadius: CGFloat = 31.8 / 2
    
    /// The distance from the center to the outside of the double ring.
    static let x2Radius: CGFloat = 170
    
    /// The distance from the center to the outside of the treble ring.
    static let x3Radius: CGFloat = 107
    
    /// Wire thickness.
    static let wireThickness: CGFloat = 1.5
    
    /// Maximum wire radius.
    static let wireRadius: CGFloat = 185            
    static let circleWireRadiuses = 6
    
    static let symbolsDistanceCoef: CGFloat = 0.87
    static let rotationAngle = Angle.degrees(Double(360 / points.count / 2))
    static let dartsCount = 3
    
    /// Getting the size (width) of a dartboard.
    static func getDartsTargetWidth(windowsSize: CGSize, hPadding: CGFloat = 24) -> CGFloat {
        windowsSize.width - hPadding.x2
    }
    
    /// Getting the radius for the target sector or dividing wire.
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
    
    /// Getting wire thickness.
    static func getWireLineWidth(_ frameWidth: CGFloat) -> CGFloat {
        frameWidth.half / DartsConstants.targetRadius * DartsConstants.wireThickness
    }
}
