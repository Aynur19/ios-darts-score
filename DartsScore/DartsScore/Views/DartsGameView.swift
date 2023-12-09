//
//  DartsGameView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameViewConstants {
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
    
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
//    @ObservedObject var appSettingsVM: AppSettingsViewModel
    
    @ObservedObject var timerVM: CountdownTimerViewModel
    @ObservedObject var gameVM: DartsGameViewModel
    @ObservedObject var dartsHitsVM: DartsHitsViewModel
    
    private var timerOptions: CountdownTimerCircleProgressBarOptions = .init()
    
//    private let appSettings: AppSettingsVM
    
    @State private var isDartsTargetSide1 = true
    @State private var rotation: Double = .zero
    
    @State private var gameViewIsShow = false
    @State private var gameStopedViewIsShow = false
    @State private var gameOverViewIsShow = false
    
    @State private var dartsTargetSide1IsShow = false
    @State private var dartsTargetSide2IsShow = false
    
    @State private var answersIsShow = true
    
    @State private var startBtnIsShow = true
    
    init(_ appSettings: AppSettings) {
        print("DartsGameView.\(#function)")
//        self.appSettings = appSettings
//        self.appSettingsVM = appSettingsVM
        
        timerOptions = CountdownTimerCircleProgressBarOptions(
            circleLineWidth: AppConstants.timerCircleLineWidth,
            circleDownColor: AppConstants.timerCircleDownColor,
            ciclreDownOpacity: AppConstants.timerCiclreDownOpacity,
            circleUpColor: AppConstants.timerCircleUpColor,
            ciclreUpOpacity: AppConstants.timerCiclreUpOpacity,
            circleUpRotation: AppConstants.timerCircleUpRotation,
            animationDuration: AppConstants.timerAnimationDuration,
            textFont: AppConstants.timerTextFont,
            textColor: AppConstants.timerTextColor,
            textIsBold: AppConstants.timerTextIsBold,
            textFormat: AppConstants.timerTextFormat
        )
        
//        let attempts = appSettingsVM .attempts
//        let timeForAnswer = appSettingsVM.timeForAnswer
//        
        gameVM = .init(appSettings.attempts, appSettings.timeForAnswer) 
        //ObservedObject(wrappedValue: DartsGameViewModel(appSettingsVM.attempts, appSettingsVM.timeForAnswer))// .init( attempts, timeForAnswer)
        timerVM = .init(appSettings.timeForAnswer) //ObservedObject(wrappedValue: CountdownTimerViewModel(appSettingsVM.timeForAnswer)) ///.init(timeForAnswer)
        dartsHitsVM = .init(options: .init()) // .init(options: .init(appSettings))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                gameView
                gameOverView
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("viewTitle_Darts")
                        .font(.title)
                        .foregroundStyle(Palette.bgText)
                }
            }
        }
        .onAppear { resetGame() }
        .onDisappear { stopGame() }
        .onReceive(gameVM.$state) { gameState in
            showUI(gameState)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            stopGame()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            stopGame()
        }
        .background()
    }
    
    private var gameView: some View {
        ZStack {
            VStack {
                topView
                dartsView
                    .frame(width: AppConstants.dartsFrameWidth,
                           height: AppConstants.dartsFrameWidth)
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
            DartsTargetView(.init())
                .overlay {
                    DartsHitsView(dartsHitsVM.darts)
                        .environmentObject(appSettingsVM)
                }
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsTargetSide1IsShow ? 1 : 0)
            
            DartsTargetView(.init())
                .overlay {
                    DartsHitsView(dartsHitsVM.darts)
                        .environmentObject(appSettingsVM)
                }
                .rotation3DEffect(.degrees(Constants.rotationAngle), axis: Constants.darts3DRotationAxis)
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsTargetSide2IsShow ? 1 : 0)
        }
    }
    
    private var answers: some View {
        VStack(spacing: 20) {
            Text("label_HowHitPoins")
                .font(.headline)
                .foregroundStyle(Palette.bgText)
            
            HStack(spacing: Constants.answersSpasing) {
                ForEach(gameVM.currentAnswers, id: \.self) { answer in
                    DartsGameAnswerView(answer) { onAnswered(answer) }
                }
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
        Button { startGame() } label: { Text("btnLabel_Start") }
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
        Button { startGame() } label: { Text("btnLabel_Resume") }
            .buttonStyle(PrimaryButtonStyle())
    }
    
    private var restartButton: some View {
        Button { restartGame() } label: { Text("btnLabel_Restart") }
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
                .foregroundStyle(Palette.bgText)
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
        Text("label_AttemptsRemaining \(gameVM.remainingAttempts)")
            .font(.headline)
            .foregroundStyle(Palette.bgText)
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
        if isRestart {
            gameVM.restart(appSettingsVM.attempts, appSettingsVM.timeForAnswer)
        } else {
            gameVM.reset()
        }
        
        timerVM.reset(gameVM.timeForAnswer)
        dartsHitsVM.reset()
        
        answersIsShow = false
        showDartsSide()
    }
    
    private func startGame() {
        gameVM.start()
        timerVM.start(gameVM.timeForAnswer)
        
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
        
        timerVM.start(gameVM.timeForAnswer)
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

//#Preview {
//    DartsGameView(.shared, .init())
//}
