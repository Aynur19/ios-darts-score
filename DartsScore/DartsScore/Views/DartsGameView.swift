//
//  DartsGameView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI
import AVFoundation

private struct DartsGameViewConstants {
    static let opacityAnimationDuration: CGFloat = 0.5
    static let darts3DRotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 1, z: 0)
    
    static let answersSpasing: CGFloat = 10
    static let buttonsVSpasing: CGFloat = 32
    static let buttonsHPadding: CGFloat = 64
    static let labelsVSpacing: CGFloat = 20
    static let rotationAngle: Double = 180
    
    static let dartsTargetHPadding: CGFloat = 32
}

struct DartsGameView: View {
    private typealias Constants = DartsGameViewConstants
    
    @Environment(\.mainWindowSize) var windowSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @StateObject var timerVM = CountdownTimerViewModel(
        AppConstants.defaultTimeForAnswer,
        timeLeftToNotify: AppConstants.timerTimeLeftToNotify
    )
    
    @StateObject var gameVM = DartsGameViewModel(
        appSettings: .init()
    )
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.defaultDartsTargetWidth
    )
    
    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.defaultDartsTargetWidth),
        missesIsEnabled: AppConstants.defaultDartsWithMiss,
        dartSize: AppConstants.defaultDartSize,
        dartImageName: AppConstants.defaultDartImageName
    )
    
    @State private var isDartsTargetSide1 = true
    @State private var rotation: Double = .zero
    
    @State private var gameStopedViewIsShow = false
    @State private var gameOverViewIsShow = false
    
    @State private var dartsTargetSide1IsShow = false
    @State private var dartsTargetSide2IsShow = false
    
    @State private var answersIsShow = true
    @State private var startBtnIsShow = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                gameView
                
                if gameOverViewIsShow {
                    GameOverPopupView(
                        action: { gameOverBtnAction() }
                    )
                    .environmentObject(gameVM)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .zIndex(1)
                    .onAppear {
                        gameVM.playResultSound()
                    }
                }
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
        .onReceive(timerVM.$isNotified) { isNotified in
            playTimerSound(isNotified)
        }
        .onReceive(timerVM.$state) { newState in
            onTimerStateChange(state: newState)
        }
        .onReceive(gameVM.$state) { gameState in
            showUI(gameState)
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willResignActiveNotification
            )
        ) { _ in stopGame() }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willTerminateNotification
            )
        ) { _ in stopGame() }
    }
    
    private var gameView: some View {
        ZStack {
            VStack {
                topView
                dartsView
                    .frame(width: dartsTargetWidth, height: dartsTargetWidth)

                ZStack {
                    gameViewButtons
                    gameStopedViewButtons
                }
                
                Spacer()
            }
        }
    }
    
    private var topView: some View {
        HStack {
            attemptsLabel
            Spacer()
            timerView
        }
        .padding(.horizontal, 32)
    }
    
    private var attemptsLabel: some View {
        Text("label_AttemptsRemaining \(gameVM.remainingAttempts)")
            .font(.headline)
            .foregroundStyle(Palette.bgText)
    }
    
    private var timerView: some View {
        CountdownTimerCircleProgressBar(
            lineWidth: AppConstants.timerCircleLineWidth,
            backForegroundStyle: {
                AppConstants.timerCircleDownColor
                    .opacity(AppConstants.timerCiclreDownOpacity)
            },
            frontForegroundStyle: {
                Palette.options1
                    .opacity(AppConstants.timerCiclreUpOpacity)
            },
            contentView: {
                Text(TimerStringFormat.secMs.msStr(timerVM.counter))
                    .font(.headline)
                    .bold()
                    .foregroundStyle(Palette.options1)
            }
        )
        .environmentObject(timerVM)
        .frame(width: 64)
    }
    
    private var dartsView: some View {
        ZStack {
            DartsTargetView()
                .environmentObject(dartsTargetVM)
                .overlay {
                    DartsHitsView()
                        .environmentObject(dartsHitsVM)
                }
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2), value: rotation)
                .opacity(dartsTargetSide1IsShow ? 1 : 0)
            
            DartsTargetView()
                .environmentObject(dartsTargetVM)
                .overlay {
                    DartsHitsView()
                        .environmentObject(dartsHitsVM)
                }
                .rotation3DEffect(.degrees(Constants.rotationAngle), axis: Constants.darts3DRotationAxis)
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2), value: rotation)
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
                    DartsGameAnswerView(
                        score: answer,
                        onAnswered: { nextAttempt(answer: answer) }
                    )
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
}

extension DartsGameView {
    private var dartsTargetWidth: CGFloat {
        DartsConstants.getDartsTargetWidth(windowsSize: windowSize)
    }
    
    private func showUI(_ gameState: DartsGameViewModel.GameState) {
        startBtnIsShow          = gameState == .idle
        gameStopedViewIsShow    = gameState == .stoped
    }
    
    private func restartGame() {
        print("DartsGameView.\(#function)")
        resetGame(isRestart: true)
    }
    
    private func resetGame(isRestart: Bool = false) {
        print("DartsGameView.\(#function)")
        if isRestart {
            gameVM.restart(appSettings: appSettingsVM.settings)
        } else {
            gameVM.reset(appSettings: appSettingsVM.settings)
        }
        
        timerVM.reset(
            gameVM.game.timeForAnswer,
            timeLeftToNotify: AppConstants.timerTimeLeftToNotify
        )
        
        dartsTargetVM.reset(
            frameWidth: dartsTargetWidth
        )
        
        dartsHitsVM.reset(
            dartsTarget: dartsTargetVM.model,
            missesIsEnabled: gameVM.game.dartsWithMiss,
            dartSize: appSettingsVM.interfaceSettings.dartSize,
            dartImageName: appSettingsVM.interfaceSettings.dartImageName
        )
        
        answersIsShow = false
        showDartsSide()
    }
    
    private func startGame() {
        print("DartsGameView.\(#function)")
        gameVM.start()
        timerVM.start()
        
        updateAnswers()
    }
    
    private func updateAnswers() {
        print("DartsGameView.\(#function)")
        dartsHitsVM.updateDarts()
        gameVM.generateAnswers(expectedScore: dartsHitsVM.score)
        answersIsShow = true
    }
    
    private func playTimerSound(_ isNotified: Bool) {
        if isNotified {
//            SoundManager.shared.play(TimerEndSound())
        }
    }
    
    private func stopTimerSound() {
//        SoundManager.shared.stop(TimerEndSound())
    }
    
    private func onTimerStateChange(state: CountdownTimerState) {
        if state == .finished {
            nextAttempt()
        }
    }
    
    private func nextAttempt(answer: Int? = .none) {
        if timerVM.isNotified { stopTimerSound() }
        
        if let currentAnswer = answer {
            gameVM.onAnswered(
                for: timerVM.counter,
                expected: dartsHitsVM.score,
                actual: currentAnswer,
                darts: dartsHitsVM.darts
            )
        } else {
            gameVM.onMissed(
                expected: dartsHitsVM.score,
                darts: dartsHitsVM.darts
            )
        }
        
        rotateDarts()
        answersIsShow = false
        
        if gameVM.state == .processing {
            continueGame()
        } else if gameVM.state == .finished {
            finishGame()
        }
    }
    
    private func rotateDarts() {
        print("DartsGameView.\(#function)")
        isDartsTargetSide1.toggle()
        rotation += Constants.rotationAngle
        
//        SoundManager.shared.play(DartsTargetRotationSound())
    }
    
    private func continueGame() {
        print("DartsGameView.\(#function)")
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            showDartsSide()
            
            await MainActor.run { updateAnswers() }
        }
        
        timerVM.reset()
        timerVM.start()
    }
    
    private func showDartsSide() {
        dartsTargetSide1IsShow = isDartsTargetSide1
        dartsTargetSide2IsShow = !isDartsTargetSide1
    }
    
    private func stopGame() {
        timerVM.stop()
        gameVM.stop()
        
        SoundManager.shared.stop()
    }
    
    private func finishGame() {
        timerVM.stop()
        answersIsShow = false
        
        withAnimation {
            gameOverViewIsShow = true
        }
    }
    
    private func gameOverBtnAction() {
        gameVM.stopResultSound()
        withAnimation {
            gameOverViewIsShow = false
        }
        restartGame()
    }
    
    private func onTimerStateChanged(state: CountdownTimerState) {
        if state == .finished {
            
        }
    }
}

private struct TestDartsGameView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                DartsGameView()
                    .environment(\.mainWindowSize, geometry.size)
                    .environmentObject(appSettingsVM)
                    .tabItem {
                        Label("viewTitle_Darts", systemImage: "gamecontroller")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

#Preview {
    TestDartsGameView()
}
