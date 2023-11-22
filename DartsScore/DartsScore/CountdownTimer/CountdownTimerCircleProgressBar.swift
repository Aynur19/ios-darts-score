//
//  CountdownTimerCircleProgressBar.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct CountdownTimerCircleProgressBar: View {
    @ObservedObject var timerVM: CountdownTimerViewModel
    private let options: CountdownTimerCircleProgressBarOptions
    
    init(
        _ seconds: Int,
        options: CountdownTimerCircleProgressBarOptions = .init()
    ) {
        self.timerVM = .init(seconds)
        self.options = options
    }
    
    init(timerVM: CountdownTimerViewModel, options: CountdownTimerCircleProgressBarOptions = .init()) {
        self.timerVM = timerVM
        self.options = options
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: options.circleLineWidth)
                .foregroundColor(options.circleDownColor)
                .opacity(options.ciclreDownOpacity)
            
            Circle()
                .trim(from: .zero, to: timerVM.progress)
                .stroke(style: StrokeStyle(lineWidth: options.circleLineWidth,
                                           lineCap: .round,
                                           lineJoin: .round))
                .foregroundColor(options.circleUpColor)
                .opacity(options.ciclreUpOpacity)
                .rotationEffect(options.circleUpRotation)
                .animation(.linear(duration: options.animationDuration), value: timerVM.progress)
            
            Text(options.textFormat.msStr(timerVM.counter))
                .font(options.textFont)
                .bold(options.textIsBold)
                .foregroundColor(options.textColor)
        }
    }
}

struct CountdownTimerCircleProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimerCircleProgressBar(47)
    }
}
