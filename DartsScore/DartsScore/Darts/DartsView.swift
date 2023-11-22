//
//  DartsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct DartsView: View {
    @ObservedObject var dartsVM: DartsViewModel
    @StateObject var appSettings = AppSettings.shared
    
    init(_ dartsVM: DartsViewModel) {
        self.dartsVM = dartsVM
    }
    
    var body: some View {
        dartsView
    }
    
    private var dartsView: some View {
        Circle()
            .frame(width: appSettings.dartsFrameWidth)
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        let center = CGPoint.getCenter(from: geometry)
                        
                        sector(in: center)
                        wireLineView(in: center)
                        
                        Circle()
                            .fill(appSettings.points25Color)
                            .frame(width: dartsVM.points25Radius.x2)
                            .position(center)
                        
                        Circle()
                            .fill(appSettings.bullEyeColor)
                            .frame(width: dartsVM.bullEyeRadius.x2)
                            .position(center)
                        
                        ForEach(0..<AppSettings.wireRadiusesCount, id: \.self) { radiusIdx in
                            Circle()
                                .stroke(appSettings.wireColor, lineWidth: dartsVM.wireLineWidth)
                                .frame(width: dartsVM.getRadius(radiusIdx).x2)
                                .position(center)
                        }
                        
                        dartsNumbers(at: center)
                        
                        ForEach(dartsVM.darts) { dart in
                            Image(systemName: appSettings.dartImageName.rawValue)
                                .resizable()
                                .frame(width: appSettings.dartImageSize,
                                       height: appSettings.dartImageSize)
                                .bold()
                                .position(dart.globalPosition(center: center))
                                .foregroundColor(appSettings.dartImageColor)
                        }
                    }
                }
            }
    }
    
    private func dartsNumbers(at center: CGPoint) -> some View {
        ForEach(dartsVM.dartTargetSectors.indices, id: \.self) { sectorIdx in
            let angle = -CGFloat(sectorIdx) * 2 * .pi / CGFloat(DartsConstants.points.count)
            let distance = appSettings.dartsFrameWidth.half * DartsConstants.symbolsDistanceCoef
            
            let x = center.x + cos(angle) * distance
            let y = center.y + sin(angle) * distance
            
            Text("\(DartsConstants.points[sectorIdx])")
                .position(x: x, y: y)
                .foregroundColor(appSettings.dartsSectorNumberColor)
                .bold()
        }
    }
    
    // MARK: Sector View
    private func sector(in center: CGPoint) -> some View {
        ZStack {
            ForEach(dartsVM.dartTargetSectors.indices, id: \.self) { sectorIdx in
                sectorPath(in: center,
                           radius: dartsVM.x2Radius,
                           sector: dartsVM.dartTargetSectors[sectorIdx])
                .fill(appSettings.getSectorColor(for: sectorIdx, false))
                
                sectorPath(in: center,
                           radius: dartsVM.baseBigRadius,
                           sector: dartsVM.dartTargetSectors[sectorIdx])
                .fill(appSettings.getSectorColor(for: sectorIdx))
                    
                sectorPath(in: center,
                           radius: dartsVM.x3Radius,
                           sector: dartsVM.dartTargetSectors[sectorIdx])
                .fill(appSettings.getSectorColor(for: sectorIdx, false))
                  
                sectorPath(in: center,
                           radius: dartsVM.baseSmallRadius,
                           sector: dartsVM.dartTargetSectors[sectorIdx])
                .fill(appSettings.getSectorColor(for: sectorIdx))
            }
        }
    }
    
    private func sectorPath(in center: CGPoint, radius: CGFloat, sector: DartsTargetSector) -> Path {
        return Path { path in
            path.move(to: center)
            
            if let points = DartsConstants.points.first, sector.points != points {
                path.addArc(center: center,
                            radius: radius,
                            startAngle: sector.minAngle,
                            endAngle: sector.maxAngle,
                            clockwise: false)
            } else {
                path.addArc(center: center,
                            radius: radius,
                            startAngle: -sector.minAngle,
                            endAngle: sector.minAngle,
                            clockwise: false)
            }
        }
    }
    
    // MARK: Wire Line View
    private func wireLineView(in center: CGPoint) -> some View {
        ForEach(dartsVM.dartTargetSectors.indices, id: \.self) { sectorIdx in
            let angle = sectorIdx == 0
            ? dartsVM.dartTargetSectors[sectorIdx].maxAngle
            : dartsVM.dartTargetSectors[sectorIdx].minAngle
            
            wireLinePath(in: center, radius: dartsVM.wireRadius, angle: angle)
                .stroke(appSettings.wireColor, lineWidth: dartsVM.wireLineWidth)
        }
    }
    
    private func wireLinePath(in center: CGPoint, radius: CGFloat, angle: Angle) -> Path {
        let point = CGPoint(x: center.x + cos(angle.radians) * radius,
                            y: center.y + sin(angle.radians) * radius)
        
        return Path { path in
            path.move(to: center)
            path.addLine(to: point)
        }
    }
}

#Preview {
    DartsView(.init())
}
