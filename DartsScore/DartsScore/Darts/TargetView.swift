//
//  DartsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct TargetView: View {
    @StateObject var appSettings = AppSettings.shared
    private let options: TargetViewOptions
    
    init(_ options: TargetViewOptions) {
        self.options = options
    }
    
    var body: some View {
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
                        
                        wirePath(in: center)
                            .stroke(appSettings.wireColor,
                                    lineWidth: options.wireLineWidth)
                        
                        Circle()
                            .fill(appSettings.points25Color)
                            .frame(width: options.points25Radius.x2)
                            .position(center)
                        
                        Circle()
                            .fill(appSettings.bullEyeColor)
                            .frame(width: options.bullEyeRadius.x2)
                            .position(center)
                        
                        dartsNumbers(at: center)
                    }
                }
            }
    }
    
    private func dartsNumbers(at center: CGPoint) -> some View {
        ForEach(DartsConstants.points.indices, id: \.self) { sectorIdx in
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
        
        let innerRadius1 = isBaseSector ? options.points25Radius : options.baseSmallRadius
        let outherRadius1 = isBaseSector ? options.baseSmallRadius : options.x3Radius
        
        let innerRadius2 = isBaseSector ? options.x3Radius : options.baseBigRadius
        let outherRadius2 = isBaseSector ? options.baseBigRadius : options.x2Radius
        
        return ZStack {
            Path { path in
                if isEven {
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: -options.rotationAngle,
                        endAngle: options.rotationAngle,
                        innerRadius: innerRadius1,
                        outerRadius: outherRadius1
                    ))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: -options.rotationAngle,
                        endAngle: options.rotationAngle,
                        innerRadius: innerRadius2,
                        outerRadius: outherRadius2
                    ))
                }
                
                for sectorIdx in 1..<DartsConstants.points.count
                where sectorIdx % 2 == checkNumber {
                    let startAngle = Angle.degrees(Double(360 / DartsConstants.points.count * sectorIdx))
                    let endAngle = Angle.degrees(Double(360 / DartsConstants.points.count * (sectorIdx + 1)))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: startAngle - options.rotationAngle,
                        endAngle: endAngle - options.rotationAngle,
                        innerRadius: innerRadius1,
                        outerRadius: outherRadius1
                    ))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: startAngle - options.rotationAngle,
                        endAngle: endAngle - options.rotationAngle,
                        innerRadius: innerRadius2,
                        outerRadius: outherRadius2
                    ))
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
        Path { path in
            
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
        }
    }
    
    // MARK: Wire Paths
    private func wirePath(in center: CGPoint) -> Path {
        Path { path in
            for radiusIdx in 0..<AppSettings.wireRadiusesCount {
                let radius = options.getRadius(radiusIdx)
                
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360),
                    clockwise: true
                )
            }
             
            for angleIdx in DartsConstants.points.indices {
                let angle = Angle.degrees(Double(360 / DartsConstants.points.count * angleIdx))
                
                path.addPath(wireLinePath(
                    in: center,
                    radius: options.wireRadius,
                    angle: angle + options.rotationAngle
                ))
            }
        }
    }

    private func wireLinePath(in center: CGPoint, radius: CGFloat, angle: Angle) -> Path {
        Path { path in
            path.move(to: center)
            path.addLine(to: .radiusPoint(
                center: center,
                radius: radius,
                angle: angle
            ))
        }
    }
}

#Preview {
    TargetView(.init())
}
