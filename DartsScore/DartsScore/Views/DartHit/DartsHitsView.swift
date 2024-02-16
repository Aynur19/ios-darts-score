//
//  DartsHitsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct DartsHitsView: View {
    @EnvironmentObject var dartsHitsVM: DartsHitsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint.getCenter(from: geometry)
            
            ForEach(dartsHitsVM.darts) { dart in
                ZStack {
                    Circle()
                        .fill(dartsHitsVM.dartPositionColor(dart))
                        .frame(width: 3)
                        .position(dart.globalPosition(center: center))
                    
                    dartsHitsVM.dartImageName
                        .image(size: dartsHitsVM.dartSize)
                        .position(dartsHitsVM.dartPosition(dart, center: center))
                }
            }
        }
    }
}


// MARK: Preview
private struct TestDartsHitsView: View {
    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: 350),
        missesIsEnabled: true,
        dartSize: 30,
        dartImageName: .dart1Rotate180
    )
    
    var body: some View {
        VStack {
            DartsHitsView()
                .environmentObject(dartsHitsVM)
            
            Button(
                action: { dartsHitsVM.updateDarts() },
                label: { Text("UPDATE DARTS") }
            )
        }
    }
}

#Preview { TestDartsHitsView() }
