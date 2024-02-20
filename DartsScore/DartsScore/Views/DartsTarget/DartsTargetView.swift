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
    private let dartsTargetPalette: DartsTargetPalette = .classic
    
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
        return ForEach(DartsConstants.points.indices, id: \.self) { sectorIdx in
            
            let position = getNumberPosition(at: center, for: sectorIdx)
            
            Text(String(DartsConstants.points[sectorIdx]))
                .position(position)
                .foregroundColor(dartsTargetPalette.dartsSectorNumberColor)
                .bold()
        }
    }
    
    private func getNumberPosition(at center: CGPoint, for idx: Int) -> CGPoint {
        let angle = -CGFloat(idx).x2 * .pi / CGFloat(DartsConstants.points.count)
        
        let x = center.x + cos(angle) * dartsTargetVM.numbersDistance
        let y = center.y + sin(angle) * dartsTargetVM.numbersDistance
        
        return .init(x: x, y: y)
    }
    
    // MARK: Sector View
    private func sector(in center: CGPoint, isEven: Bool = true, isBaseSector: Bool = true) -> some View {
        let checkNumber: Int = isEven ? .zero : 1
        
        let innerRadiuses = dartsTargetVM.getInnerRadiuses(isBaseSector)
        let outherRadiuses = dartsTargetVM.getOutherRadiuses(isBaseSector)
        
        return ZStack {
            Path { path in
                if isEven {
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: -dartsTarget.rotationAngle,
                        endAngle: dartsTarget.rotationAngle,
                        innerRadius: innerRadiuses[0],
                        outerRadius: outherRadiuses[0]
                    ))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: -dartsTarget.rotationAngle,
                        endAngle: dartsTarget.rotationAngle,
                        innerRadius: innerRadiuses[1],
                        outerRadius: outherRadiuses[1]
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
                        innerRadius: innerRadiuses[0],
                        outerRadius: outherRadiuses[0]
                    ))
                    
                    path.addPath(sectorPath(
                        in: center,
                        startAngle: startAngle - dartsTarget.rotationAngle,
                        endAngle: endAngle - dartsTarget.rotationAngle,
                        innerRadius: innerRadiuses[1],
                        outerRadius: outherRadiuses[1]
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


// MARK: Preview
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
                DartsTargetView()
                    .environmentObject(dartsTargetVM)
                    .overlay {
                        DartsHitsView()
                            .environmentObject(dartsHitsVM)
                    }
                
                Spacer()
                
                Button(
                    action: { dartsHitsVM.updateDarts() },
                    label: { Text("UPDATE DARTS") }
                )
                
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

#Preview { TestDartsTargetView() }
