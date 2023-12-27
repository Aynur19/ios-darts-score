//
//  CountdownTimerCircleProgressBar.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct CountdownTimerCircleProgressBar<BackShapeStyleType, FrontShapeStyleType, ContentViewType>: View
where BackShapeStyleType: ShapeStyle,
      FrontShapeStyleType: ShapeStyle,
      ContentViewType: View {
    
    @EnvironmentObject var timerVM: CountdownTimerViewModel
    
    private let lineWidth: CGFloat
    private let circleRotation: Angle
    private let animationDuration: Double
    
    private let backForegroundStyle: () -> BackShapeStyleType
    private let frontForegroundStyle: () -> FrontShapeStyleType
    
    @ViewBuilder private var contentView: ContentViewType
    
    init(
        lineWidth: CGFloat = 20,
        circleRotation: Angle = .degrees(-90),
        animationDuration: Double = 0.2,
        backForegroundStyle: @escaping () -> BackShapeStyleType = { Color.gray.opacity(0.25) },
        frontForegroundStyle: @escaping () -> FrontShapeStyleType = { Color.green },
        @ViewBuilder contentView: () -> ContentViewType
    ) {
        self.lineWidth = lineWidth
        self.circleRotation = circleRotation
        self.animationDuration = animationDuration
         
        self.backForegroundStyle = backForegroundStyle
        self.frontForegroundStyle = frontForegroundStyle
        
        self.contentView = contentView()
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(backForegroundStyle())
            
            Circle()
                .trim(from: .zero, to: timerVM.progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round,
                                           lineJoin: .round))
                .foregroundStyle(frontForegroundStyle())
                .rotationEffect(circleRotation)
                .animation(.linear(duration: animationDuration), value: timerVM.progress)
            
            contentView
        }
    }
}

private struct TestCountdownTimerCircleProgressBarView: View {
    @StateObject var timerVM = CountdownTimerViewModel(47_000)
    
    var body: some View {
        VStack {
            CountdownTimerCircleProgressBar(
                contentView: {
                    Text(TimerStringFormat.secMs.msStr(timerVM.counter))
                        .font(.headline)
                        .bold()
                        .foregroundStyle(Color.green)
                }
            )
            .environmentObject(timerVM)
            .padding()
            
            VStack(spacing: 16) {
                Button { timerVM.reset() } label: { Text("RESET") }
                Button { timerVM.start() } label: { Text("START") }
                Button { timerVM.stop() } label: { Text("STOP") }
            }
            .padding()
        }
    }
}

#Preview {
    TestCountdownTimerCircleProgressBarView()
}
