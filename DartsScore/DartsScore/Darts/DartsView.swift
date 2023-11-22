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
                        
                        sector(in: center, isBaseSector: false)
                        sector(in: center, isEven: false, isBaseSector: false)
                        
                        sector(in: center)
                        sector(in: center, isEven: false)
                        
                        wireLineView(in: center)
                        
                        Circle()
                            .fill(appSettings.points25Color)
                            .frame(width: dartsVM.points25Radius.x2)
                            .position(center)
                        
                        Circle()
                            .fill(appSettings.bullEyeColor)
                            .frame(width: dartsVM.bullEyeRadius.x2)
                            .position(center)
                        
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
    private func sector(
        in center: CGPoint,
        isEven: Bool = true,
        isBaseSector: Bool = true
    ) -> some View {
        let checkNumber = isEven ? 0 : 1
        
        let innerRadius1 = isBaseSector ? dartsVM.points25Radius : dartsVM.baseSmallRadius
        let outherRadius1 = isBaseSector ? dartsVM.baseSmallRadius : dartsVM.x3Radius
        
        let innerRadius2 = isBaseSector ? dartsVM.x3Radius : dartsVM.baseBigRadius
        let outherRadius2 = isBaseSector ? dartsVM.baseBigRadius : dartsVM.x2Radius
        
        return ZStack {
            Path { path in
                if isEven {
                    path.addPath(
                        sectorPath(
                            in: center,
                            startAngle: -dartsVM.dartTargetSectors[0].minAngle,
                            endAngle: dartsVM.dartTargetSectors[0].minAngle,
                            innerRadius: innerRadius1,
                            outerRadius: outherRadius1
                        )
                    )
                    
                    path.addPath(
                        sectorPath(
                            in: center,
                            startAngle: -dartsVM.dartTargetSectors[0].minAngle,
                            endAngle: dartsVM.dartTargetSectors[0].minAngle,
                            innerRadius: innerRadius2,
                            outerRadius: outherRadius2
                        )
                    )
                }
                
                for sectorIdx in 1..<dartsVM.dartTargetSectors.count
                where sectorIdx % 2 == checkNumber {
                    path.addPath(
                        sectorPath(
                            in: center,
                            startAngle: dartsVM.dartTargetSectors[sectorIdx].minAngle,
                            endAngle: dartsVM.dartTargetSectors[sectorIdx].maxAngle,
                            innerRadius: innerRadius1,
                            outerRadius: outherRadius1
                        )
                    )
                    
                    path.addPath(
                        sectorPath(
                            in: center,
                            startAngle: dartsVM.dartTargetSectors[sectorIdx].minAngle,
                            endAngle: dartsVM.dartTargetSectors[sectorIdx].maxAngle,
                            innerRadius: innerRadius2,
                            outerRadius: outherRadius2
                        )
                    )
                }
            }.fill(appSettings.getSectorColor(for: checkNumber, isBaseSector))
        }
    }
    
    private func sectorPath(
        in center: CGPoint,
        startAngle: Angle,
        endAngle: Angle,
        innerRadius: CGFloat,
        outerRadius: CGFloat
    ) -> Path {
        var path = Path()
        
        path.move(to: .radiusPoint(
            center: center,
            radius: innerRadius,
            angle: startAngle
        ))
        
        path.addArc(
            center: center,
            radius: outerRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        path.addLine(to: .radiusPoint(
            center: center,
            radius: outerRadius,
            angle: endAngle
        ))
        
        path.addArc(
            center: center,
            radius: innerRadius,
            startAngle: endAngle,
            endAngle: startAngle,
            clockwise: true
        )
        
        return path
    }
    
    // MARK: Wire Line View
    private func wireLineView(in center: CGPoint) -> some View {
        wirePath(in: center)
            .stroke(appSettings.wireColor, lineWidth: dartsVM.wireLineWidth)
    }
    
    private func wirePath(in center: CGPoint) -> Path {
        var path = Path()
        var angle = dartsVM.dartTargetSectors[0].maxAngle
        
        for radiusIdx in 0..<AppSettings.wireRadiusesCount {
            path.addPath(
                wireCirclePath(
                    in: center,
                    radius: dartsVM.getRadius(radiusIdx),
                    startAngle: dartsVM.dartTargetSectors[0].minAngle,
                    endAngle: dartsVM.dartTargetSectors[0].maxAngle,
                    withReverce: true
                )
            )
        }
        
        path.addPath(
            wireLinePath(
                in: center,
                radius: dartsVM.wireRadius,
                angle: angle
            )
        )
        
        for sectorIdx in 1..<dartsVM.dartTargetSectors.count {
            angle = dartsVM.dartTargetSectors[sectorIdx].minAngle
            path.addPath(
                wireLinePath(
                    in: center,
                    radius: dartsVM.wireRadius,
                    angle: angle
                )
            )
        }
        
        return path
    }
    
    private func wireCirclePath(
        in center: CGPoint,
        radius: CGFloat,
        startAngle: Angle,
        endAngle: Angle,
        withReverce: Bool = false
    ) -> Path {
        Path { path in
            path.move(to: center)
            
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            
            if withReverce {
                path.move(to: center)
                
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true
                )
            }
        }
    }

    private func wireLinePath(in center: CGPoint, radius: CGFloat, angle: Angle) -> Path {
        let point = CGPoint.radiusPoint(center: center, radius: radius, angle: angle)
        
        return Path { path in
            path.move(to: center)
            path.addLine(to: point)
        }
    }
}

#Preview {
    DartsView(.init())
}
