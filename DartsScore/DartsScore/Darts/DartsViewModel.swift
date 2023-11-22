//
//  DartsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

class DartsViewModel: ObservableObject {
    private let distanceWithoutScore: CGFloat
    private let maxDartRadius: CGFloat
    
    let wireLineWidth: CGFloat
    let rotationAngle: Angle
    
    let bullEyeRadius: CGFloat
    let points25Radius: CGFloat
    let x3Radius: CGFloat
    let x2Radius: CGFloat
    let baseSmallRadius: CGFloat
    let baseBigRadius: CGFloat
    let wireRadius: CGFloat
    let appSettings: AppSettings
    
    // MARK: Variables
    @Published private(set) var darts = [Dart]()
    @Published private(set) var score: Int = .zero
    
    private(set) var dartTargetSectors = [DartsTargetSector]()
    
    // MARK: Init
    init() {
        appSettings = AppSettings.shared
        
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
        
        prepareDartsTargetSectors()
    }
    
    func reset() {
        darts.removeAll()
        score = .zero
    }
    
    func updateDarts() {
        generateDarts()
        updateScore()
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
    
    private func prepareDartsTargetSectors() {
        var minAngle = rotationAngle
        var maxAngle = Angle.circle - rotationAngle
        
        for points in DartsConstants.points {
            dartTargetSectors.append(.init(from: minAngle, to: maxAngle, points: points))
            
            if dartTargetSectors.count == 1 { maxAngle = minAngle }
            
            minAngle = maxAngle
            maxAngle = minAngle + rotationAngle + rotationAngle
        }
    }
    
    private func generateDarts() {
        darts.removeAll()
        for _ in 0..<appSettings.dartsCount {
            darts.append(generateDart())
        }
    }
    
    private func generateDart() -> Dart {
        var sector: DartsSector = .init(.wire)
        var position: CGPoint = .zero
        
        while sector.area == .wire {
            let angle = CGFloat(Angle.randomCircleSector().degrees)
            let distance = CGFloat.random(in: 0...maxDartRadius)
            
            position = CGPoint.init(x: distance * cos(angle),
                                    y: distance * sin(angle))
            sector = getSector(at: position)
        }
        
        return .init(for: position, in: sector)
    }
    
    private func updateScore() {
        score = darts.reduce(0, { currentScore, dart in
            return currentScore + dart.sector.points * dart.sector.xScore
        })
    }
    
    private func getSector(at localPoint: CGPoint) -> DartsSector {
        let angle = Angle.trigonometric(at: localPoint)
        let distance = CGPoint.distance(to: localPoint)
        
        var isOutSectors = false
        var isWireLineTouched = false
        var sector: DartsSector = .init(.outOfPoints)
        
        isOutSectors = checkOutOfSectors(distance: distance)
        if isOutSectors { return sector }
        
        sector = getCircleSector(distance: distance)
        if sector.points != 0 { return sector }
        
        isWireLineTouched = checkTouchedOfWire(at: localPoint, angle: angle, distance: distance)
        if isWireLineTouched { return sector }
        
        sector = getSector(angle: angle, distance: distance)
        return sector
    }
    
    private func checkOutOfSectors(distance: CGFloat) -> Bool {
        distance > x2Radius + distanceWithoutScore
    }
    
    private func getCircleSector(distance: CGFloat) -> DartsSector {
        if distance <= bullEyeRadius - wireLineWidth {
            return .init(.bullEye)
        }
        
        if distance > bullEyeRadius + wireLineWidth,
           distance < points25Radius - wireLineWidth {
            return .init(.points25)
        }
        
        return .init(.wire)
    }
    
    private func checkTouchedOfWire(at touchPoint: CGPoint, angle: Angle, distance: CGFloat) -> Bool {
        for radiusIdx in 0..<AppSettings.wireRadiusesCount 
        where abs(distance - getRadius(radiusIdx)) <= distanceWithoutScore { return true }
        
        for sector in dartTargetSectors {
            let angle = CGFloat(sector.maxAngle.radians)
            let wirePoint = CGPoint.init(x: distance * cos(angle),
                                         y: distance * sin(angle))
            let distanceToWire = CGPoint.distance(from: wirePoint, to: touchPoint)
            
            if distanceToWire <= distanceWithoutScore { return true }
        }
        
        return false
    }
    
    private func getSector(angle: Angle, distance: CGFloat) -> DartsSector {
        let xScore = getXScore(distance)
        let angle2 = angle.trigonometric
        
        for idx in dartTargetSectors.indices {
            let isInSector: Bool
            let sector = dartTargetSectors[idx]
            
            if idx == 0 {
                isInSector = angle2 < sector.minAngle || angle2 > sector.maxAngle
            } else {
                isInSector = sector.minAngle < angle2 && sector.maxAngle > angle2
            }
            
            if isInSector {
                return .init(points: dartTargetSectors[idx].points, xScore: xScore)
            }
        }
        
        return .init(.wire)
    }
    
    private func getXScore(_ distance: CGFloat) -> Int {
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
