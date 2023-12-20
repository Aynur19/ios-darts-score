//
//  DartsTargetView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct DartsTargetView: View {
    @EnvironmentObject var dartsTargetVM: DartsTargetViewModel
    
    private let sectorsCount = DartsConstants.points.count
    private let dartsTargetPalette: DartsTargetPalette
    
    init(dartsTargetPalette: DartsTargetPalette) {
        self.dartsTargetPalette = dartsTargetPalette
    }
    
    var body: some View {
        Circle()
            .fill(Color.black)
            .frame(width: dartsTarget.frameWidth)
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        let center = CGPoint.getCenter(from: geometry)
                        
                        sector(in: center, isBaseSector: false)
                        sector(in: center, isEven: false, isBaseSector: false)
                        
                        sector(in: center)
                        sector(in: center, isEven: false)
                        
                        wirePath(in: center)
                            .stroke(dartsTargetPalette.wireColor,
                                    lineWidth: dartsTarget.wireLineWidth)
                        
                        Circle()
                            .fill(dartsTargetPalette.points25Color)
                            .frame(width: dartsTarget.points25Radius.x2)
                            .position(center)
                        
                        Circle()
                            .fill(dartsTargetPalette.bullEyeColor)
                            .frame(width: dartsTarget.bullEyeRadius.x2)
                            .position(center)
                        
                        dartsNumbers(at: center)
                    }
                }
            }
    }
    
    private var dartsTarget: DartsTarget { dartsTargetVM.model }
    
    private func dartsNumbers(at center: CGPoint) -> some View {
        ForEach(DartsConstants.points.indices, id: \.self) { sectorIdx in
            let angle = -CGFloat(sectorIdx).x2 * .pi / CGFloat(DartsConstants.points.count)
            let distance = dartsTarget.maxRadius * DartsConstants.symbolsDistanceCoef
            
            let x = center.x + cos(angle) * distance
            let y = center.y + sin(angle) * distance
            
            Text(String(DartsConstants.points[sectorIdx]))
                .position(x: x, y: y)
                .foregroundColor(dartsTargetPalette.dartsSectorNumberColor)
                .bold()
        }
    }
    
    // MARK: Sector View
    private func sector(in center: CGPoint, isEven: Bool = true, isBaseSector: Bool = true) -> some View {
        let checkNumber: Int = isEven ? .zero : 1
        
        let innerRadius1 = isBaseSector ? dartsTarget.points25Radius : dartsTarget.baseSmallRadius
        let outherRadius1 = isBaseSector ? dartsTarget.baseSmallRadius : dartsTarget.x3Radius
        
        let innerRadius2 = isBaseSector ? dartsTarget.x3Radius : dartsTarget.baseBigRadius
        let outherRadius2 = isBaseSector ? dartsTarget.baseBigRadius : dartsTarget.x2Radius
        
        return ZStack {
            Path { path in
                if isEven {
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: -dartsTarget.rotationAngle,
                        endAngle: dartsTarget.rotationAngle,
                        innerRadius: innerRadius1,
                        outerRadius: outherRadius1
                    ))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: -dartsTarget.rotationAngle,
                        endAngle: dartsTarget.rotationAngle,
                        innerRadius: innerRadius2,
                        outerRadius: outherRadius2
                    ))
                }
                
                for sectorIdx in 1..<DartsConstants.points.count
                where sectorIdx % 2 == checkNumber {
                    let startAngle = Angle.degrees(Double(360 / sectorsCount * sectorIdx))
                    let endAngle = Angle.degrees(Double(360 / sectorsCount * (sectorIdx + 1)))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: startAngle - dartsTarget.rotationAngle,
                        endAngle: endAngle - dartsTarget.rotationAngle,
                        innerRadius: innerRadius1,
                        outerRadius: outherRadius1
                    ))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: startAngle - dartsTarget.rotationAngle,
                        endAngle: endAngle - dartsTarget.rotationAngle,
                        innerRadius: innerRadius2,
                        outerRadius: outherRadius2
                    ))
                }
            }
            .fill(dartsTargetPalette.getSectorColor(for: checkNumber, isBaseSector))
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
            for radiusIdx in 0..<DartsConstants.circleWireRadiuses {
                let radius = dartsTarget.getRadius(radiusIdx)
                
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(.zero),
                    endAngle: .circle,
                    clockwise: true
                )
            }
             
            for angleIdx in DartsConstants.points.indices {
                let angle = Angle.degrees(Double(360 / sectorsCount * angleIdx))
                
                path.addPath(wireLinePath(
                    in: center,
                    radius: dartsTarget.wireRadius,
                    angle: angle + dartsTarget.rotationAngle
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

private struct TestDartsTargetView: View {
    @StateObject var dartsTargetVM = DartsTargetViewModel(frameWidth: 350)
    @ObservedObject var dartsHitsVM =  DartsHitsViewModel(
        dartsTarget: .init(frameWidth: 350),
        missesIsEnabled: true,
        dartSize: 10,
        dartImageName: .dart1
    )
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack {
                DartsTargetView(dartsTargetPalette: .classic)
                    .environmentObject(dartsTargetVM)
                    .overlay {
                        DartsHitsView()
                            .environmentObject(dartsHitsVM)
                    }
                
                Spacer()
                
                Button {
                    dartsHitsVM.updateDarts()
                } label: {
                    Text("UPDATE DARTS")
                }
                
                Spacer()
                
                if dartsHitsVM.darts.count == 3 {
                    Text("Dart sector 1: \(darts[0].sector.points)x\(darts[0].sector.xScore)")
                    Text("Dart sector 1: \(darts[1].sector.points)x\(darts[1].sector.xScore)")
                    Text("Dart sector 1: \(darts[2].sector.points)x\(darts[2].sector.xScore)")
                }
            }
        }
        .onAppear {
            dartsHitsVM.reset(
                dartsTarget: dartsTargetVM.model,
                missesIsEnabled: false,
                dartSize: 30,
                dartImageName: .dart2
            )
        }
    }
    
    private var darts: [Dart] { dartsHitsVM.darts }
}

#Preview {
    TestDartsTargetView()
}
