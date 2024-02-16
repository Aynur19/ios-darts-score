//
//  RotatedDartsTargetView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 26.12.2023.
//

import SwiftUI

struct RotatedDartsTargetView: View {
    @EnvironmentObject var dartsTargetVM: DartsTargetViewModel
    @EnvironmentObject var dartsHitsVM: DartsHitsViewModel
    
    private let size: CGFloat
    @Binding var rotation: Double
    @Binding var showSide1: Bool
    @Binding var showSide2: Bool
    
    init(
        size: CGFloat,
        rotation: Binding<Double>,
        showSide1: Binding<Bool>,
        showSide2: Binding<Bool>
    ) {
        self.size = size
        _rotation = rotation
        _showSide1 = showSide1
        _showSide2 = showSide2
    }
    
    var body: some View {
        ZStack {
            DartsTargetView()
                .environmentObject(dartsTargetVM)
                .overlay {
                    DartsHitsView()
                        .environmentObject(dartsHitsVM)
                }
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                .animation(.linear(duration: 1), value: rotation)
                .opacity(showSide1 ? 1 : 0)
            
            DartsTargetView()
                .environmentObject(dartsTargetVM)
                .overlay {
                    DartsHitsView()
                        .environmentObject(dartsHitsVM)
                }
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                .animation(.linear(duration: 1), value: rotation)
                .opacity(showSide2 ? 1 : 0)
        }
        .frame(width: size, height: size)
    }
}


// MARK: Preview
private struct TestRotatedDartsTargetView: View {
    @StateObject var dartsTargetVM = DartsTargetViewModel(frameWidth: 350)
    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: 350),
        missesIsEnabled: true,
        dartSize: 30,
        dartImageName: .dart3
    )
    
    @State private var rotation: Double = 0
    @State private var showSide1: Bool = true
    @State private var showSide2: Bool = false
    
    var body: some View {
        ZStack {
            Palette.background.ignoresSafeArea()
            
            VStack {
                Spacer()
                RotatedDartsTargetView(
                    size: 350,
                    rotation: $rotation,
                    showSide1: $showSide1,
                    showSide2: $showSide2
                )
                .environmentObject(dartsTargetVM)
                .environmentObject(dartsHitsVM)
                
                Spacer()
                
                Button(
                    action: { action() },
                    label: { Text("UPDATE") }
                )
                Spacer()
            }
        }
    }
    
    private func action() {
        rotation += 180
        
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            showSide1.toggle()
            showSide2.toggle()
            
            await MainActor.run {
                dartsHitsVM.updateDarts()
            }
        }
    }
}

#Preview { TestRotatedDartsTargetView() }
