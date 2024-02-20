//
//  DartsTarget.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 16.12.2023.
//

import SwiftUI

struct DartsTarget {
    let rotationAngle: Angle = DartsConstants.rotationAngle
    let sectors = DartsConstants.points.count
    
    private(set) var frameWidth: CGFloat = .zero
    
    private(set) var distanceWithoutScore: CGFloat = .zero
    private(set) var maxRadius: CGFloat = .zero
    
    private(set) var wireLineWidth: CGFloat = .zero
    
    private(set) var bullEyeRadius: CGFloat = .zero
    private(set) var points25Radius: CGFloat = .zero
    private(set) var x3Radius: CGFloat = .zero
    private(set) var x2Radius: CGFloat = .zero
    private(set) var baseSmallRadius: CGFloat = .zero
    private(set) var baseBigRadius: CGFloat = .zero
    private(set) var wireRadius: CGFloat = .zero
    
    private(set) var numbersDistance: CGFloat = .zero
    
    init(frameWidth: CGFloat) {
        update(frameWidth: frameWidth)
    }
    
    mutating func update(frameWidth: CGFloat) {
        self.frameWidth = frameWidth
        wireLineWidth = DartsConstants.getWireLineWidth(frameWidth)
        distanceWithoutScore = wireLineWidth.x2.x2
        maxRadius = frameWidth.half
        
        bullEyeRadius = DartsConstants.getRadius(frameWidth, .bullEye)
        points25Radius = DartsConstants.getRadius(frameWidth, .points25)
        x3Radius = DartsConstants.getRadius(frameWidth, .x3)
        x2Radius = DartsConstants.getRadius(frameWidth, .x2)
        baseSmallRadius = DartsConstants.getRadius(frameWidth, .baseSmall)
        baseBigRadius = DartsConstants.getRadius(frameWidth, .baseBig)
        wireRadius = DartsConstants.getRadius(frameWidth, .wire)
        numbersDistance = maxRadius * DartsConstants.symbolsDistanceCoef
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
    
    func getCircleSector(distance: CGFloat) -> DartsSector {
        if distance <= bullEyeRadius - wireLineWidth {
            return .init(.bullEye)
        }
        
        if distance > bullEyeRadius + wireLineWidth,
           distance < points25Radius - wireLineWidth {
            return .init(.points25)
        }
        
        return .init(.wire)
    }
    
    func checkTouchedOfWire(at touchPoint: CGPoint, angle: Angle, distance: CGFloat) -> Bool {
        for radiusIdx in 0..<DartsConstants.circleWireRadiuses
        where abs(distance - getRadius(radiusIdx)) <= distanceWithoutScore { return true }
        
        for idx in DartsConstants.points.indices {
            let angle = CGFloat((Angle.circleSector(idx: idx, from: sectors) + rotationAngle).radians)
            let wirePoint = CGPoint.init(x: distance * cos(angle),
                                         y: distance * sin(angle))
            let distanceToWire = CGPoint.distance(from: wirePoint, to: touchPoint)
            
            if distanceToWire <= distanceWithoutScore { return true }
        }
        
        return false
    }
    
    func getScoreX(_ distance: CGFloat) -> Int {
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
    
    func checkOutOfSectors(_ distance: CGFloat) -> Bool {
        distance > x2Radius + distanceWithoutScore
    }
    
    func getSector(angle: Angle, distance: CGFloat) -> DartsSector {
        let xScore = getScoreX(distance)
        let angle = angle.trigonometric
        
        for idx in DartsConstants.points.indices {
            let isInSector: Bool
            let sectorMinAngle: Angle
            let sectorMaxAngle: Angle
            
            if idx == 0 {
                sectorMinAngle = rotationAngle
                sectorMaxAngle = Angle.circle - rotationAngle
                isInSector = angle < sectorMinAngle || angle > sectorMaxAngle
            } else {
                sectorMinAngle = Angle.circleSector(idx: idx, from: sectors) - rotationAngle
                sectorMaxAngle = sectorMinAngle + rotationAngle + rotationAngle
                isInSector = sectorMinAngle < angle && sectorMaxAngle > angle
            }
            
            if isInSector {
                return .init(idx, points: DartsConstants.points[idx], xScore: xScore)
            }
        }
        
        return .init(.wire)
    }
}
