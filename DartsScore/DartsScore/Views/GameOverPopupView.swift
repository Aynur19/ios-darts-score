//
//  GameOverPopupView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 17.12.2023.
//

import SwiftUI

struct GameOverPopupView: View {
    @EnvironmentObject var gameVM: DartsGameViewModel
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void = { }) {
        self.action = action
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            
            VStack(spacing: 16) {
                Text("Результаты")
                
                Spacer()
                attemptsLabel
                successLabel
                withoutAnswerLabel
                scoreLabel
                timeLabel
                
                Spacer()
                resultLabel
                
                Spacer()
                okButton
            }
            .foregroundStyle(Palette.btnPrimary)
            .font(.title3)
            .padding(32)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 32)
        .padding(.vertical, 128)
    }
    
    private var game: DartsGame { gameVM.game }
    
    private var attemptsLabel: some View {
        HStack {
            Text("Попыток: ")
            Spacer()
            Text("\(game.attempts)")
        }
    }
    
    private var successLabel: some View {
        HStack {
            Text("Правильных: ")
            Spacer()
            Text("\(game.correct)")
        }
    }
    
    private var withoutAnswerLabel: some View {
        HStack {
            Text("Без ответов: ")
            Spacer()
            Text("\(game.missed)")
        }
    }
    
    private var scoreLabel: some View {
        HStack {
            Text("Очков: ")
            Spacer()
            Text("\(game.score)")
        }
    }
    
    private var timeLabel: some View {
        HStack {
            Text("Время: ")
            Spacer()
            Text("\(TimerStringFormat.secMs.msStr(game.timeSpent)) сек.")
        }
    }
    
    private var isGoodResult: Bool {
        game.correct >= game.attempts - game.correct
    }
    
    private var resultLabel: some View {
        isGoodResult
        ? Text("Хороший результат!")
        : Text("Можно и лучше!")
    }
    
    private var okButton: some View {
        Button(
            action: { action() },
            label: { Text("OK") }
        )
        .foregroundStyle(Palette.btnPrimary)
        .bold()
    }
}

struct TestGameOverView: View {
    @StateObject var gameVM = DartsGameViewModel(appSettings: .init())
    @StateObject var dartsTargetVM = DartsTargetViewModel(frameWidth: 350)
    @State private var popupIsShow = false
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                DartsTargetView()
                    .environmentObject(dartsTargetVM)
                
                Button {
                    withAnimation {
                        popupIsShow.toggle()
                    }
                } label: {
                    Text("POPUP")
                }
                
                Spacer()
            }
            
            if popupIsShow {
                GameOverPopupView(
                    action: {
                        withAnimation {
                            popupIsShow.toggle()
                        }
                    }
                )
                .environmentObject(gameVM)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                .zIndex(1)
            }
        }
    }
}

#Preview {
    TestGameOverView()
}
