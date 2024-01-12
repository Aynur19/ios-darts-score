//
//  DartsGameView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameViewConstants {
    static let opacityAnimationDuration: CGFloat = 0.5
    
    static let buttonsVSpasing: CGFloat = 32
    static let buttonsHPadding: CGFloat = 64
    static let labelsVSpacing: CGFloat = 20
}

struct DartsGameView: View {
    private typealias Constants = DartsGameViewConstants
    
    private let notifyCenter = NotificationCenter.default
    
    @Environment(\.dartsTargetSize) var dartsTargetSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @StateObject var timerVM = CountdownTimerViewModel(
        AppDefaultSettings.timeForAnswer,
        timeLeftToNotify: AppConstants.timerNotifyTime
    )
    
    @StateObject var gameVM = DartsGameViewModel(
        attempts: AppDefaultSettings.attempts,
        timeForAnswer: AppDefaultSettings.timeForAnswer,
        missesIsEnabled: AppInterfaceDefaultSettings.dartMissesIsEnabled
    )
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.dartsTargetWidth
    )
    
    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.dartsTargetWidth),
        missesIsEnabled: AppInterfaceDefaultSettings.dartMissesIsEnabled,
        dartSize: AppInterfaceDefaultSettings.dartSize,
        dartImageName: AppInterfaceDefaultSettings.dartImageName
    )
    
    @State private var rotation: Double = .zero
    
    @State private var gameStopedViewIsShow = false
    @State private var gameOverViewIsShow = false
    
    @State private var showSide1 = true
    @State private var showSide2 = false
    
    @State private var answersIsShow = true
    @State private var startBtnIsShow = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                StaticUI.background
                gameView
                resultsPopup
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                StaticUI.toolbarTitle { Text("viewTitle_Darts") }
            }
        }
        .onAppear { resetGame() }
        .onDisappear { stopGame() }
        .onReceive(gameVM.$state) { gameState in
            showUI(gameState)
        }
        .onReceive(notifyCenter.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            stopGame()
        }
        .onReceive(notifyCenter.publisher(for: UIApplication.willTerminateNotification)) { _ in
            stopGame()
        }
    }
    
    // MARK: Timer
    private var timerView: some View {
        GameTimerView()
            .environmentObject(timerVM)
            .frame(width: 64)
            .onReceive(timerVM.$state) { newState in
                onTimerStateChanged(state: newState)
            }
            .onReceive(timerVM.$isNotified) { isNotified in
                onTimerIsNotified(isNotified)
            }
    }
    
    private func onTimerStateChanged(state: CountdownTimerState) {
        if state == .finished {
            nextAttempt()
        }
    }
    
    private func onTimerIsNotified(_ isNotified: Bool) {
        if isNotified {
            SoundManager.shared.play(.timerEnd)
        }
    }
    
    private func stopTimerSound() {
        SoundManager.shared.stop(.timerEnd)
    }
    
    // MARK: Darts Game
    private var gameView: some View {
        ZStack {
            VStack {
                topView
                dartsView
                
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
    
    private var dartsView: some View {
        RotatedDartsTargetView(
            size: dartsTargetSize,
            rotation: $rotation,
            showSide1: $showSide1,
            showSide2: $showSide2
        )
        .environmentObject(dartsTargetVM)
        .environmentObject(dartsHitsVM)
    }
    
    private var answers: some View {
        GameAnswersListView(answers: gameVM.currentAnswers) { answer in
            nextAttempt(answer: answer)
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
        Button(
            action: { startGame() },
            label: { Text("btnLabel_Start") }
        )
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
        Button(
            action: { startGame() },
            label: { Text("btnLabel_Resume") }
        )
        .buttonStyle(PrimaryButtonStyle())
    }
    
    private var restartButton: some View {
        Button(
            action: { resetGame(isRestart: true) },
            label: { Text("btnLabel_Restart") }
        )
        .buttonStyle(PrimaryButtonStyle())
    }
    
    // MARK: Game Results Popup
    @ViewBuilder
    private var resultsPopup: some View {
        if gameOverViewIsShow {
            GameOverPopup(
                game: gameVM.game,
                action: { popupAction() }
            )
            .transition(.asymmetric(insertion: .scale, removal: .opacity))
            .zIndex(1)
            .onAppear { gameVM.playResultSound() }
        }
    }
    
    private func popupAction() {
        gameVM.stopResultSound()
        
        withAnimation {
            gameOverViewIsShow = false
        }
        
        resetGame(isRestart: true)
    }
}

extension DartsGameView {
    private var appSettings: AppSettings { appSettingsVM.settings }
    
    private var interfaceSettings: AppInterfaceSettings { appSettingsVM.interfaceSettings }
    
    private var soundSettings: AppSoundSettings { appSettingsVM.soundSettings }
    
    private func showUI(_ gameState: DartsGameViewModel.GameState) {
        startBtnIsShow          = gameState == .idle
        gameStopedViewIsShow    = gameState == .stoped
    }
    
    private func resetGame(isRestart: Bool = false) {
        appSettingsVM.update()
        
        gameVM.reset(
            attempts: appSettings.attempts,
            timeForAnswer: appSettings.timeForAnswer,
            missesIsEnabled: interfaceSettings.dartMissesIsEnabled,
            isRestart: isRestart
        )
        
        timerVM.reset(
            gameVM.game.timeForAnswer,
            timeLeftToNotify: AppConstants.timerNotifyTime
        )
        
        dartsTargetVM.reset(
            frameWidth: dartsTargetSize
        )
        
        dartsHitsVM.reset(
            dartsTarget: dartsTargetVM.model,
            missesIsEnabled: gameVM.game.missesIsEnabled,
            dartSize: appSettingsVM.interfaceSettings.dartSize,
            dartImageName: appSettingsVM.interfaceSettings.dartImageName
        )
        
        answersIsShow = false
        showSide1 = true
        showSide2 = false
    }
    
    private func startGame() {
        gameVM.start()
        timerVM.start()
        updateAnswers()
    }
    
    private func updateAnswers() {
        dartsHitsVM.updateDarts()
        gameVM.generateAnswers(expectedScore: dartsHitsVM.score)
        answersIsShow = true
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
        
        answersIsShow = false
        
        if gameVM.state == .processing {
            continueGame()
        } else if gameVM.state == .finished {
            finishGame()
        }
    }
    
    private func continueGame() {
        rotation += 180
        
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            await MainActor.run {
                showSide1.toggle()
                showSide2.toggle()
                updateAnswers()
            }
        }
        
        timerVM.reset()
        timerVM.start()
    }
    
    private func stopGame() {
        timerVM.reset()
        gameVM.stop()
        
        answersIsShow = false
        dartsHitsVM.reset()
    }
    
    private func finishGame() {
        timerVM.stop()
        answersIsShow = false
        
        withAnimation {
            gameOverViewIsShow = true
        }
    }
}

private struct TestDartsGameView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                DartsGameView()
                    .environment(\.dartsTargetSize,
                                  DartsConstants.getDartsTargetWidth(windowsSize: geometry.size))
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
