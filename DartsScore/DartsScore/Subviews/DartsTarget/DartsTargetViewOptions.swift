//
//  DartsTargetViewOptions.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct DartsTargetViewOptions {
    let distanceWithoutScore: CGFloat
    let maxDartRadius: CGFloat
    
    let wireLineWidth: CGFloat
    let rotationAngle: Angle
    
    let bullEyeRadius: CGFloat
    let points25Radius: CGFloat
    let x3Radius: CGFloat
    let x2Radius: CGFloat
    let baseSmallRadius: CGFloat
    let baseBigRadius: CGFloat
    let wireRadius: CGFloat
    
    init(_ appSettings: AppSettings = .shared) {
        let dartsFrameWidth = appSettings.dartsFrameWidth
        self.wireLineWidth = DartsConstants.getWireLineWidth(dartsFrameWidth)
        self.rotationAngle = DartsConstants.getRotationAngle(for: DartsConstants.points.count)
        self.distanceWithoutScore = wireLineWidth.x2.x2
        self.maxDartRadius = dartsFrameWidth.half
        
        self.bullEyeRadius = DartsConstants.getRadius(dartsFrameWidth, .bullEye)
        self.points25Radius = DartsConstants.getRadius(dartsFrameWidth, .points25)
        self.x3Radius = DartsConstants.getRadius(dartsFrameWidth, .x3)
        self.x2Radius = DartsConstants.getRadius(dartsFrameWidth, .x2)
        self.baseSmallRadius = DartsConstants.getRadius(dartsFrameWidth, .baseSmall)
        self.baseBigRadius = DartsConstants.getRadius(dartsFrameWidth, .baseBig)
        self.wireRadius = DartsConstants.getRadius(dartsFrameWidth, .wire)
    }
    
    func getRadius(_ idx: Int) -> CGFloat {
        switch idx {
            case 0: return x2Radius
            case 1: return baseBigRadius
            case 2: return x3Radius
            case 3: return baseSmallRadius
            case 4: return points25Radius
            default: return bullEyeRadius
        }
    }
    
    func checkOutOfSectors(distance: CGFloat) -> Bool {
        distance > x2Radius + distanceWithoutScore
    }
    
    func getXScore(_ distance: CGFloat) -> Int {
        if distance > baseSmallRadius + distanceWithoutScore,
           distance < x3Radius - distanceWithoutScore {
            return DartsConstants.x3Score
        }
        
        if distance > baseBigRadius + distanceWithoutScore,
           distance < x2Radius - distanceWithoutScore {
            return DartsConstants.x2Score
        }
        
        return DartsConstants.x1Score
    }
}
