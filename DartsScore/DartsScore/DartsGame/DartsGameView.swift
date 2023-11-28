//
//  DartsGameView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameViewConstants {
    static let title = "Дартс"
    static let startBtnLabel = "НАЧАТЬ"
    static let resumeBtnLabel = "ПРОДОЛЖИТЬ"
    static let restartBtnLabel = "ЗАНОВО"
    static let attemptsRemainingLabel = "Осталось попыток: "
    static let opacityAnimationDuration: CGFloat = 0.5
    static let darts3DRotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 1, z: 0)
    
    static let answersSpasing: CGFloat = 10
    static let buttonsVSpasing: CGFloat = 32
    static let buttonsHPadding: CGFloat = 64
    static let labelsVSpacing: CGFloat = 20
    static let rotationAngle: Double = 180
}

struct DartsGameView: View {
    private typealias Constants = DartsGameViewConstants
    
    @ObservedObject var timerVM: CountdownTimerViewModel
    @ObservedObject var gameVM: DartsGameViewModel
    @ObservedObject var dartsHitsVM: DartsHitsViewModel
    
    private var timerOptions: CountdownTimerCircleProgressBarOptions = .init()
    
    private let appSettings: AppSettings
    
    @State private var isDartsTargetSide1 = true
    @State private var rotation: Double = .zero
    
    @State private var gameViewIsShow = false
    @State private var gameStopedViewIsShow = false
    @State private var gameOverViewIsShow = false
    
    @State private var dartsTargetSide1IsShow = false
    @State private var dartsTargetSide2IsShow = false
    
    @State private var answersIsShow = true
    
    @State private var startBtnIsShow = true
    
    init(_ appSettings: AppSettings = .shared) {
        self.appSettings = appSettings
        
        timerOptions = CountdownTimerCircleProgressBarOptions(
            circleLineWidth: appSettings.timerCircleLineWidth,
            circleDownColor: appSettings.timerCircleDownColor,
            ciclreDownOpacity: appSettings.timerCiclreDownOpacity,
            circleUpColor: appSettings.pallet.optionsColor1,
            ciclreUpOpacity: appSettings.timerCiclreUpOpacity,
            circleUpRotation: appSettings.timerCircleUpRotation,
            animationDuration: appSettings.timerAnimationDuration,
            textFont: appSettings.timerTextFont,
            textColor: appSettings.pallet.optionsColor1,
            textIsBold: appSettings.timerTextIsBold,
            textFormat: appSettings.timerTextFormat
        )
        
        timerVM = .init(appSettings.timeForAnswer)
        gameVM = .init(appSettings: appSettings)
        dartsHitsVM = .init(.init(appSettings))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                appSettings.pallet.background
                    .ignoresSafeArea()
                gameView
                gameOverView
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    viewTitle(Constants.title)
                }
            }
        }
        .onAppear { resetGame() }
        .onDisappear { stopGame() }
        .onReceive(gameVM.$state) { gameState in
            showUI(gameState)
        }
        .background()
    }
    
    private var gameView: some View {
        ZStack {
            VStack {
                topView
                dartsView
                    .frame(width: appSettings.dartsFrameWidth,
                           height: appSettings.dartsFrameWidth)
                ZStack {
                    gameViewButtons
                    gameStopedViewButtons
                }
                
                Spacer()
            }
        }
        .opacity(gameViewIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: gameViewIsShow)
    }
    
    private var topView: some View {
        HStack {
            attemptsLabel
            Spacer()
            CountdownTimerCircleProgressBar(timerVM: timerVM, options: timerOptions)
                .frame(width: 64)
        }
        .padding(.horizontal, 32)
    }
    
    private var dartsView: some View {
        ZStack {
            DartsTargetView(.init(), appSettings: appSettings)
                .overlay {
                    DartsHitsView(dartsHitsVM.darts, appSettings: appSettings)
                }
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsTargetSide1IsShow ? 1 : 0)
            
            DartsTargetView(.init(), appSettings: appSettings)
                .overlay {
                    DartsHitsView(dartsHitsVM.darts, appSettings: appSettings)
                }
                .rotation3DEffect(.degrees(Constants.rotationAngle), axis: Constants.darts3DRotationAxis)
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsTargetSide2IsShow ? 1 : 0)
        }
    }
    
    private var answers: some View {
        HStack(spacing: Constants.answersSpasing) {
            ForEach(gameVM.currentAnswers, id: \.self) { answer in
                DartsGameAnswerView(answer) { onAnswered(answer) }
            }
        }
        .opacity(answersIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: answersIsShow)
    }
    
    private var gameViewButtons: some View {
        VStack(spacing: Constants.buttonsVSpasing) {
            Spacer()
            answers
            startButton
                .padding(.horizontal, Constants.buttonsHPadding)
            Spacer()
        }
    }
    
    private var startButton: some View {
        Button { startGame() } label: { Text(Constants.startBtnLabel) }
            .buttonStyle(PrimaryButtonStyle())
            .opacity(startBtnIsShow ? 1 : 0)
            .animation(.linear(duration: Constants.opacityAnimationDuration), value: startBtnIsShow)
    }
    
    private var gameStopedViewButtons: some View {
        VStack(spacing: Constants.buttonsVSpasing) {
            Spacer()
            resumeButton
            restartButton
            Spacer()
        }
        .padding(.horizontal, Constants.buttonsHPadding)
        
        .opacity(gameStopedViewIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: gameStopedViewIsShow)
    }
    
    private var resumeButton: some View {
        Button { startGame() } label: { Text(Constants.resumeBtnLabel) }
            .buttonStyle(PrimaryButtonStyle())
    }
    
    private var restartButton: some View {
        Button { restartGame() } label: { Text(Constants.restartBtnLabel) }
            .buttonStyle(PrimaryButtonStyle())
    }
    
    private var gameOverView: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(spacing: Constants.labelsVSpacing) {
                    statsLabel("Всего попыток: ", .init(gameVM.game.attempts))
                    statsLabel("Правильных ответов: ", .init(gameVM.game.successAttempts))
                    statsLabel("Заработано очков: ", .init(gameVM.game.score))
                    statsLabel("Потрачено времени: ", "\(TimerStringFormat.secMs.msStr( gameVM.game.timeSpent)) сек.")
                }
                .foregroundStyle(appSettings.pallet.bgTextColor)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Constants.buttonsHPadding.half)
                
                Spacer()
                
                restartButton
                    .padding(.horizontal, Constants.buttonsHPadding)
                
                Spacer()
            }
        }
        .opacity(gameOverViewIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: gameOverViewIsShow)
    }
    
    private var attemptsLabel: some View {
        label("\(Constants.attemptsRemainingLabel) \(gameVM.remainingAttempts)")
    }
    
    private func statsLabel(_ text1: String, _ text2: String) -> some View {
        HStack {
            Text(text1)
            Spacer()
            Text(text2)
        }
    }
}

extension DartsGameView {
    private func showUI(_ gameState: DartsGameViewModel.GameState) {
        startBtnIsShow          = gameState == .idle
        gameStopedViewIsShow    = gameState == .stoped
        gameViewIsShow          = gameState != .finished
        gameOverViewIsShow      = gameState == .finished
    }
    
    private func restartGame() {
        resetGame(isRestart: true)
    }
    
    private func resetGame(isRestart: Bool = false) {
        gameVM.reset(isRestart: isRestart)
        dartsHitsVM.reset()
        timerVM.reset(appSettings.timeForAnswer)
        
        answersIsShow = false
        showDartsSide()
    }
    
    private func startGame() {
        gameVM.start()
        timerVM.start(appSettings.timeForAnswer)
        
        updateAnswers()
    }
    
    private func updateAnswers() {
        dartsHitsVM.updateDarts()
        gameVM.generateAnswers(dartsHitsVM.score)
        answersIsShow = true
    }
    
    private func onAnswered(_ answer: Int) {
        gameVM.onAnswered(
            for: timerVM.counter,
            expected: dartsHitsVM.score,
            actual: answer,
            darts: dartsHitsVM.darts
        )
        
        rotateDarts()
        answersIsShow = false
        
        if gameVM.state == .processing {
            continueGame()
        } else if gameVM.state == .finished {
            finishGame()
        }
    }
    
    private func rotateDarts() {
        isDartsTargetSide1.toggle()
        rotation += Constants.rotationAngle
    }
    
    private func continueGame() {
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            showDartsSide()
            
            await MainActor.run { updateAnswers() }
        }
        
        timerVM.start(appSettings.timeForAnswer)
    }
    
    private func showDartsSide() {
        dartsTargetSide1IsShow = isDartsTargetSide1
        dartsTargetSide2IsShow = !isDartsTargetSide1
    }
    
    private func stopGame() {
        timerVM.stop()
        gameVM.stop()
        
        resetGame()
    }
    
    private func finishGame() {
        timerVM.stop()
        answersIsShow = false
    }
}

#Preview {
    DartsGameView()
}
