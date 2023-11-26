//
//  DartsGameView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private enum DartsGameSubview {
    case topView
    
    case dartsView
    case dartsView1
    case dartsView2
    
    case gameOverView
    case answersView
    
    case startBtnView
    case resumeBtnView
    case restartBtnView
}

private struct DartsGameViewConstants {
    static let opacityAnimationDuration: CGFloat = 0.5
    static let darts3DRotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 1, z: 0)
}

struct DartsGameView: View {
    private typealias Constants = DartsGameViewConstants
    
    @ObservedObject var dartsVM = DartsHitsViewModel(.init())
    @ObservedObject var timerVM = CountdownTimerViewModel()
    @ObservedObject var gameVM = DartsGameViewModel(.init())
    
    @ObservedObject var appSettings: AppSettings = .shared
    
    private var timerOptions: CountdownTimerCircleProgressBarOptions = .init()
    
    @State private var isDarts1 = true
    @State private var rotation: Double = .zero
    
    @State private var topViewOpacity: CGFloat = .zero
    @State private var dartsOpacity: CGFloat = .zero
    @State private var dartsViewOpacity1: CGFloat = .zero
    @State private var dartsViewOpacity2: CGFloat = .zero
    
    @State private var answersOpacity: CGFloat = .zero
    
    @State private var gameOverViewOpacity: CGFloat = .zero
    
    @State private var startBtnOpacity: CGFloat = .zero
    @State private var resumeBtnOpacity: CGFloat = .zero
    @State private var restartBtnOpacity: CGFloat = .zero
    
    init() {
        timerOptions = CountdownTimerCircleProgressBarOptions(
            circleLineWidth: appSettings.timerCircleLineWidth,
            circleDownColor: appSettings.timerCircleDownColor,
            ciclreDownOpacity: appSettings.timerCiclreDownOpacity,
            circleUpColor: appSettings.timerCircleUpColor,
            ciclreUpOpacity: appSettings.timerCiclreUpOpacity,
            circleUpRotation: appSettings.timerCircleUpRotation,
            animationDuration: appSettings.timerAnimationDuration,
            textFont: appSettings.timerTextFont,
            textColor: appSettings.timerTextColor,
            textIsBold: appSettings.timerTextIsBold,
            textFormat: appSettings.timerTextFormat
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    topView
                    dartsView
                        .frame(width: appSettings.dartsFrameWidth,
                               height: appSettings.dartsFrameWidth)
                        .opacity(dartsOpacity)
                        .animation(.linear(duration: Constants.opacityAnimationDuration),
                                   value: dartsOpacity)
                    
                    VStack {
                        gameOverView
                        answers
                        Spacer()
                    }
                }
                .padding()
                    
                VStack(spacing: 20) {
                    Spacer(minLength: 600)
                    startButton
                    resumeButton
                    restartButton
                    Spacer()
                }
            }
            .navigationTitle("Дартс")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { resetGame() }
        .onDisappear { stopGame() }
    }
    
    private var topView: some View {
        HStack {
            Text("Осталось попыток: \(gameVM.remainingAttempts)")
                .font(.headline)
            Spacer()
            CountdownTimerCircleProgressBar(timerVM: timerVM,
                                            options: timerOptions)
            .frame(width: 64)
        }
        .padding(.horizontal, 32)
        .opacity(topViewOpacity)
        .animation(.linear(duration: Constants.opacityAnimationDuration),
                   value: topViewOpacity)
    }
    
    private var dartsView: some View {
        ZStack {
            DartsTargetView(.init(), appSettings: appSettings)
                .overlay {
                    DartsHitsView(dartsVM.darts, appSettings: appSettings)
                }
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsViewOpacity1)

            DartsTargetView(.init(), appSettings: appSettings)
                .overlay {
                    DartsHitsView(dartsVM.darts, appSettings: appSettings)
                }
                .rotation3DEffect(.degrees(180), axis: Constants.darts3DRotationAxis)
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsViewOpacity2)
        }
    }
    
    private var answers: some View {
        HStack(spacing: 10) {
            ForEach(gameVM.currentAnswers, id: \.self) { answer in
                DartsGameAnswerView(answer) {
                    onAnswered(answer)
                }
            }
        }
        .opacity(answersOpacity)
        .animation(.linear(duration: Constants.opacityAnimationDuration),
                   value: answersOpacity)
    }
    
    private var startButton: some View {
        Button {
            startGame()
        } label: {
            Text("НАЧАТЬ")
        }
        .opacity(startBtnOpacity)
        .animation(.linear(duration: Constants.opacityAnimationDuration),
                   value: startBtnOpacity)
    }
    
    private var resumeButton: some View {
        Button {
            startGame()
        } label: {
            Text("ПРОДОЛЖИТЬ")
        }
        .opacity(resumeBtnOpacity)
        .animation(.linear(duration: Constants.opacityAnimationDuration),
                   value: resumeBtnOpacity)
    }
    
    private var restartButton: some View {
        Button {
            restartGame()
        } label: {
            Text("ЗАНОВО")
        }
        .opacity(restartBtnOpacity)
        .animation(.linear(duration: Constants.opacityAnimationDuration),
                   value: restartBtnOpacity)
    }
    
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Text("Всего попыток: \(gameVM.model.attempts)")
            Text("Правильных ответов: \(gameVM.model.successCount)")
            Text("Заработано очков: \(gameVM.model.score)")
        }
        .font(.title2)
        .opacity(gameOverViewOpacity)
        .animation(.linear(duration: Constants.opacityAnimationDuration),
                   value: gameOverViewOpacity)
    }
    
}

extension DartsGameView {
    private func restartGame() {
        resetGame(isRestart: true)
    }
    
    private func resetGame(isRestart: Bool = false) {
        gameVM.reset(isRestart: isRestart)
        dartsVM.reset()
        timerVM.reset(appSettings.timeForAnswer)
        
        showView(for: .answersView, false)
//        showView(for: .dartsView1)
        showDartsSide()
        showView(for: .topView)
        showView(for: .dartsView)
        
        showView(for: .gameOverView, false)
        
        showView(for: .startBtnView, gameVM.state == .idle)
        showView(for: .resumeBtnView, gameVM.state == .stoped)
        showView(for: .restartBtnView, gameVM.state == .stoped)
    }
    
    private func startGame() {
        gameVM.start()
        timerVM.start(appSettings.timeForAnswer)
        
        updateAnswers()
        showView(for: .startBtnView, false)
        showView(for: .resumeBtnView, false)
        showView(for: .restartBtnView, false)
    }
    
    private func updateAnswers() {
        dartsVM.updateDarts()
        gameVM.generateAnswers(dartsVM.score)
        showView(for: .answersView)
    }
    
    private func onAnswered(_ answer: Int) {
        gameVM.onAnswered(
            answer,
            expectedScore: dartsVM.score,
            time: timerVM.counter,
            darts: dartsVM.darts
        )
        
        rotateDarts()
        showView(for: .answersView, false)
        
        if gameVM.state == .processing {
            continueGame()
        } else if gameVM.state == .finished {
            finishGame()
        }
    }
    
    private func rotateDarts() {
        isDarts1.toggle()
        rotation += 180
    }
    
    private func continueGame() {
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
//            showView(for: .dartsView1, isDarts1)
//            showView(for: .dartsView2, !isDarts1)
            showDartsSide()
            
            await MainActor.run {
                updateAnswers()
            }
        }
        
        timerVM.start(appSettings.timeForAnswer)
    }
    
    private func showDartsSide() {
        showView(for: .dartsView1, isDarts1)
        showView(for: .dartsView2, !isDarts1)
    }
    
    private func stopGame() {
        timerVM.stop()
        gameVM.stop()
        
        resetGame()
    }
    
    private func finishGame() {
        timerVM.stop()
        
        showView(for: .answersView, false)
        showView(for: .dartsView, false)
        showView(for: .topView, false)
        
        showView(for: .gameOverView)
        
        showView(for: .startBtnView, false)
        showView(for: .resumeBtnView, false)
        showView(for: .restartBtnView)
    }
    
    private func showView(for subview: DartsGameSubview, _ isShow: Bool = true) {
        let opacity: CGFloat = isShow ? 1 : .zero
        switch subview {
            case .topView:
                topViewOpacity = opacity
            case .dartsView:
                dartsOpacity = opacity
            case .dartsView1:
                dartsViewOpacity1 = opacity
            case .dartsView2:
                dartsViewOpacity2 = opacity
                
            case .answersView:
                answersOpacity = opacity
                
            case .gameOverView:
                gameOverViewOpacity = opacity
                
            case .startBtnView:
                startBtnOpacity = opacity
            case .resumeBtnView:
                resumeBtnOpacity = opacity
            case .restartBtnView:
                restartBtnOpacity = opacity
        }
    }
}

#Preview {
    DartsGameView()
}
