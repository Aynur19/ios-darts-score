//
//  DartsHitsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

class DartsHitsViewModel: ObservableObject {
    private let options: DartsTargetViewOptions
    private let sectorsCount = DartsConstants.points.count
    private let rotationAngle = DartsConstants.rotationAngle
    
    private(set) var dartsWithMiss: Bool
    private(set) var dartsSize: CGFloat
    
    @Published private(set) var darts = [Dart]()
    @Published private(set) var score: Int = .zero
    
    init(options: DartsTargetViewOptions, dartsWithMiss: Bool, dartsSize: Int) {
        self.options = options
        self.dartsWithMiss = dartsWithMiss
        self.dartsSize = CGFloat(dartsSize)
    }
    
    func reset(dartsWithMiss: Bool, dartsSize: Int) {
        self.dartsWithMiss = dartsWithMiss
        self.dartsSize = CGFloat(dartsSize)
        
        darts.removeAll()
        score = .zero
    }
    
    func updateDarts() {
        generateDarts()
        updateScore()
    }
    
    private func generateDarts() {
        darts.removeAll()
        for _ in 0..<AppConstants.dartsCount {
            darts.append(generateDart())
        }
    }
    
    private func generateDart() -> Dart {
        print("DartsHitsViewModel.\(#function)")
        print("  dartsWithMiss: \(dartsWithMiss)")
        var sector: DartsSector = .init(.wire)
        var position: CGPoint = .zero
        
        while sector.area == .wire || (!dartsWithMiss && sector.area == .outOfPoints) {
            let angle = CGFloat(Angle.randomCircleSector().degrees)
            let distance = CGFloat.random(in: 0...options.maxDartRadius)
            
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
        
        isOutSectors = options.checkOutOfSectors(distance)
        if isOutSectors { return sector }
        
        sector = getCircleSector(distance: distance)
        if sector.points != 0 { return sector }
        
        isWireLineTouched = checkTouchedOfWire(at: localPoint, angle: angle, distance: distance)
        if isWireLineTouched { return sector }
        
        sector = getSector(angle: angle, distance: distance)
        return sector
    }
    
    private func getCircleSector(distance: CGFloat) -> DartsSector {
        if distance <= options.bullEyeRadius - options.wireLineWidth {
            return .init(.bullEye)
        }
        
        if distance > options.bullEyeRadius + options.wireLineWidth,
           distance < options.points25Radius - options.wireLineWidth {
            return .init(.points25)
        }
        
        return .init(.wire)
    }
    
    private func checkTouchedOfWire(at touchPoint: CGPoint, angle: Angle, distance: CGFloat) -> Bool {
        for radiusIdx in 0..<AppConstants.wireRadiusesCount
        where abs(distance - options.getRadius(radiusIdx)) <= options.distanceWithoutScore { return true }
        
        for idx in DartsConstants.points.indices {
            let angle = CGFloat((Angle.circleSector(idx: idx, from: sectorsCount) + rotationAngle).radians)
            let wirePoint = CGPoint.init(x: distance * cos(angle),
                                         y: distance * sin(angle))
            let distanceToWire = CGPoint.distance(from: wirePoint, to: touchPoint)
            
            if distanceToWire <= options.distanceWithoutScore { return true }
        }
        
        return false
    }
    
    private func getSector(angle: Angle, distance: CGFloat) -> DartsSector {
        let xScore = options.getXScore(distance)
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
                sectorMinAngle = Angle.circleSector(idx: idx, from: sectorsCount) - rotationAngle
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
