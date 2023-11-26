//
//  DartsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

class DartsViewModel: ObservableObject {
    let appSettings: AppSettings = .shared
    let options: TargetViewOptions
    
    // MARK: Variables
    @Published private(set) var darts = [Dart]()
    @Published private(set) var score: Int = .zero
    
//    private(set) var dartTargetSectors = [DartsTargetSector]()
    
    // MARK: Init
    init(options: TargetViewOptions = .init()) {
        self.options = options
        
//        prepareDartsTargetSectors()
    }
    
    init(options: TargetViewOptions = .init(), darts: [Dart], score: Int) {
        self.options = options
        self.darts.append(contentsOf: darts)
        self.score = score
    }
    
    func reset() {
        darts.removeAll()
        score = .zero
    }
    
    func updateDarts(_ darts: [Dart] = []) {
        if !darts.isEmpty {
            self.darts.removeAll()
            self.darts.append(contentsOf: darts)
            return
        }
        
        generateDarts()
        updateScore()
    }
    
//    private func prepareDartsTargetSectors() {
//        let rotationAngle = options.rotationAngle
//        
//        var minAngle = rotationAngle
//        var maxAngle = Angle.circle - rotationAngle
//        
//        for points in DartsConstants.points {
//            dartTargetSectors.append(.init(from: minAngle, to: maxAngle, points: points))
//            
//            if dartTargetSectors.count == 1 { maxAngle = minAngle }
//            
//            minAngle = maxAngle
//            maxAngle = minAngle + rotationAngle + rotationAngle
//        }
//    }
    
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
        
        isOutSectors = options.checkOutOfSectors(distance: distance)
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
        for radiusIdx in 0..<AppSettings.wireRadiusesCount 
        where abs(distance - options.getRadius(radiusIdx)) <= options.distanceWithoutScore { return true }
        
//        for sector in dartTargetSectors {
        for idx in DartsConstants.points.indices {
            let angle = CGFloat((Angle.circleSector(idx: idx, from: DartsConstants.points.count) + options.rotationAngle).radians)// CGFloat(sector.maxAngle.radians)
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
        
        for idx in DartsConstants.points.indices {//dartTargetSectors.indices {
            let isInSector: Bool
            let sectorMinAngle: Angle
            let sectorMaxAngle: Angle
//            let sector = dartTargetSectors[idx]
            
            if idx == 0 {
                sectorMinAngle = options.rotationAngle
                sectorMaxAngle = Angle.circle - options.rotationAngle
                isInSector = angle < sectorMinAngle || angle > sectorMaxAngle
            } else {
                sectorMinAngle = Angle.circleSector(idx: idx - 1, from: DartsConstants.points.count) + options.rotationAngle
                sectorMaxAngle = Angle.circleSector(idx: idx, from: DartsConstants.points.count) + options.rotationAngle
                isInSector = sectorMinAngle < angle && sectorMaxAngle > angle
            }
            
            if isInSector {
                return .init(points: DartsConstants.points[idx], xScore: xScore)
            }
        }
        
        return .init(.wire)
    }
}
