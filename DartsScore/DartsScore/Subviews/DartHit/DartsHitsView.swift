//
//  DartsHitsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct DartsHitsView: View {
    private let darts: [Dart]
    private let dartSize: CGFloat
    private let dartImageName: DartImageName
    
    init(_ darts: [Dart], dartSize: CGFloat, dartImageName: DartImageName) {
        self.darts = darts
        self.dartSize = dartSize
        self.dartImageName = dartImageName
    }
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint.getCenter(from: geometry)
            
            ForEach(darts) { dart in
                ZStack {
                    Circle()
                        .fill(dartPositionColor(dart))
                        .frame(width: 3)
                        .position(dart.globalPosition(center: center))
                    
                    dartImageName
                        .image(size: dartSize)
                        .position(dartPosition(dart, center: center))
                }
            }
        }
    }
    
    private func dartPosition(_ dart: Dart, center: CGPoint) -> CGPoint {
        var position = dart.globalPosition(center: center)
        position.x += dartSize.half
        position.y -= dartSize.half
        
        return position
    }
    
    private func dartPositionColor(_ dart: Dart) -> Color {
        let sector = dart.sector
        
        if sector.area == .outOfPoints { return .white }
        if sector.sectorIdx % 2 == 1, sector.xScore == 1 { return .white }
        
        return .black
    }
}

private struct TestDartsHitsView: View {
    var body: some View {
        VStack {
            DartsHitsView(
                MockData.getDartsGameSnapshotsList().snapshots[0].darts,
                dartSize: 30,
                dartImageName: .dartFlipH1
            )
        }
    }
}

#Preview {
    TestDartsHitsView()
}
