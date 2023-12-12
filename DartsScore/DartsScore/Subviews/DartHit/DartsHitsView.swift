//
//  DartsHitsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct DartsHitsView: View {
    private let darts: [Dart]
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    init(_ darts: [Dart]) {
        self.darts = darts
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
                    
                    appSettingsVM.dartImageName
                        .image(size: dartSize)
                        .position(dartPosition(dart, center: center))
                }
            }
        }
    }
    
    private var dartSize: CGFloat {
        .init(appSettingsVM.dartSize)
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
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        VStack {
            Text("Dart Size: \(appSettingsVM.dartSize)")
            DartsHitsView(MockData.getDartsGameSnapshotsList().snapshots[0].darts)
                .environmentObject(appSettingsVM)
        }
        .onAppear {
            appSettingsVM.dartSize = 16
        }
    }
}

#Preview {
    TestDartsHitsView()
}
