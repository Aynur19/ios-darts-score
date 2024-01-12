//
//  DartsHitsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

class DartsHitsViewModel: ObservableObject {
    private(set) var dartsTarget: DartsTarget
    private(set) var missesIsEnabled: Bool
    
    @Published private(set) var dartSize: CGFloat
    @Published private(set) var dartImageName: DartImageName
    
    @Published private(set) var darts = [Dart]()
    @Published private(set) var score: Int = .zero
    
    init(
        dartsTarget: DartsTarget,
        missesIsEnabled: Bool,
        dartSize: Int,
        dartImageName: DartImageName
    ) {
        self.dartsTarget        = dartsTarget
        self.missesIsEnabled    = missesIsEnabled
        self.dartSize           = CGFloat(dartSize)
        self.dartImageName      = dartImageName
    }
    
    func reset(
        dartsTarget: DartsTarget,
        missesIsEnabled: Bool,
        dartSize: Int,
        dartImageName: DartImageName
    ) {
        self.dartsTarget        = dartsTarget
        self.missesIsEnabled    = missesIsEnabled
        self.dartSize           = CGFloat(dartSize)
        self.dartImageName      = dartImageName
        
        darts.removeAll()
        score = .zero
    }
    
    func reset() {
        darts.removeAll()
        score = .zero
    }
    
    func updateDarts() {
        generateDarts()
        updateScore()
    }
    
    private func generateDarts() {
        darts.removeAll()
        
        for _ in 0..<DartsConstants.dartsCount {
            darts.append(generateDart())
        }
    }
    
    private func generateDart() -> Dart {
        var sector: DartsSector = .init(.wire)
        var position: CGPoint = .zero
        
        while !validateSector(sector) {
            let angle = CGFloat(Angle.randomCircleSector().degrees)
            let distance = CGFloat.random(in: 0...dartsTarget.maxRadius)
            
            position = CGPoint.init(x: distance * cos(angle),
                                    y: distance * sin(angle))
            sector = getSector(at: position)
        }
        
        return .init(for: position, in: sector)
    }
    
    private func validateSector(_ sector: DartsSector) -> Bool {
        !(sector.area == .wire || (!missesIsEnabled && sector.area == .outOfPoints))
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
        
        isOutSectors = dartsTarget.checkOutOfSectors(distance)
        if isOutSectors { return sector }
        
        sector = dartsTarget.getCircleSector(distance: distance)
        if sector.points != 0 { return sector }
        
        isWireLineTouched = dartsTarget.checkTouchedOfWire(at: localPoint, angle: angle, distance: distance)
        if isWireLineTouched { return sector }
        
        sector = dartsTarget.getSector(angle: angle, distance: distance)
        return sector
    }
    
    func dartPosition(_ dart: Dart, center: CGPoint) -> CGPoint {
        var position = dart.globalPosition(center: center)
        position.x += dartSize.half
        position.y -= dartSize.half
        
        return position
    }
    
    func dartPositionColor(_ dart: Dart) -> Color {
        let sector = dart.sector
        
        if sector.area == .outOfPoints { return .white }
        if sector.sectorIdx % 2 == 1, sector.xScore == 1 { return .white }
        
        return .black
    }
}

extension DartsHitsViewModel {
    func replaceDarts(newDarts: [Dart]) {
        darts.removeAll()
        darts.append(contentsOf: newDarts)
        
        updateScore()
    }
    
    func updateDartView(imageName: DartImageName, size: Int) {
        dartImageName = imageName
        dartSize = CGFloat(size)
    }
}
