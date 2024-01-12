//
//  GameTimerView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 26.12.2023.
//

import SwiftUI

struct GameTimerView: View {
    @EnvironmentObject var timerVM: CountdownTimerViewModel
    
    var body: some View {
        CountdownTimerCircleProgressBar(
            lineWidth: 8,
            backForegroundStyle: { Color.gray .opacity(0.3) },
            frontForegroundStyle: { Palette.options1 },
            contentView: {
                Text(TimerStringFormat.secMs.msStr(timerVM.counter))
                    .font(.headline)
                    .bold()
                    .foregroundStyle(Palette.options1)
            }
        )
        .frame(width: 64)
    }
}

private struct TestGameTimerView: View {
    @StateObject var timerVM = CountdownTimerViewModel(20.secToMs, timeLeftToNotify: 5.secToMs)
    
    var body: some View {
        GameTimerView()
            .environmentObject(timerVM)
    }
}

#Preview {
    TestGameTimerView()
}
