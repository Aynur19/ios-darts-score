//
//  DartsTargetViewOptions.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct TargetViewOptions {
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
        self.wireLineWidth = DartsConstants.getWireLineWidth(appSettings.dartsFrameWidth)
        self.rotationAngle = DartsConstants.getRotationAngle(for: DartsConstants.points.count)
        self.distanceWithoutScore = wireLineWidth.x2
        self.maxDartRadius = appSettings.dartsFrameWidth.half
        
        self.bullEyeRadius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .bullEye)
        self.points25Radius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .points25)
        self.x3Radius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .x3)
        self.x2Radius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .x2)
        self.baseSmallRadius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .baseSmall)
        self.baseBigRadius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .baseBig)
        self.wireRadius = DartsConstants.getRadius(appSettings.dartsFrameWidth, .wire)
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
