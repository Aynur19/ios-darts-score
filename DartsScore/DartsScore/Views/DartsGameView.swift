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
        AppConstants.defaultTimeForAnswer.secToMs,
        timeLeftToNotify: AppConstants.timerTimeLeftToNotify
    )
    
    @StateObject var gameVM = DartsGameViewModel(
        appSettings: .init()
    )
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.dartsFrameWidth
    )
    
    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.dartsFrameWidth),
        missesIsEnabled: AppConstants.defaultDartsWithMiss,
        dartSize: AppConstants.defaultDartSize,
        dartImageName: AppConstants.defaultDartImageName
    )
    
    @State private var isDartsTargetSide1 = true
    @State private var rotation: Double = .zero
    
    @State private var gameViewIsShow = false
    @State private var gameStopedViewIsShow = false
    @State private var gameOverViewIsShow = false
    
    @State private var dartsTargetSide1IsShow = false
    @State private var dartsTargetSide2IsShow = false
    
    @State private var answersIsShow = true
    @State private var startBtnIsShow = true
    
//    init(_ appSettings: AppSettings) {
//        print("DartsGameView.\(#function)")
//        
//        gameVM = .init(appSettings)
//        
//        dartsTargetVM = .init(frameWidth: <#T##CGFloat#>)
//        
//        dartsHitsVM = .init(
//            dartsTarget: .init(frameWidth: 300),
//            missesIsEnabled: appSettings.dartsWithMiss,
//            dartSize: appSettings.dartSize,
//            dartImageName: appSettings.dartImageName
//        )
//    }
    
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
        .onAppear {
            resetGame()
        }
        .onDisappear { stopGame() }
        .onReceive(timerVM.$isNotified) { isNotified in
            if isNotified {
                playTimerSound()
            }
        }
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
                    .frame(width: dartsTargetWidth, height: dartsTargetWidth)

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
    
    private var dartsTargetWidth: CGFloat {
        windowSize.width - Constants.dartsTargetHPadding.x2
    }
    
    private var topView: some View {
        HStack {
            attemptsLabel
            Spacer()
            timerView
        }
        .padding(.horizontal, 32)
    }
    
    private var timerView: some View {
        CountdownTimerCircleProgressBar(
            timerVM: timerVM,
            lineWidth: AppConstants.timerCircleLineWidth,
            backForegroundStyle: {
                AppConstants.timerCircleDownColor
                    .opacity(AppConstants.timerCiclreDownOpacity)
            },
            frontForegroundStyle: {
                AppConstants.timerCircleUpColor
                    .opacity(AppConstants.timerCiclreUpOpacity)
            },
            contentView: {
                Text(TimerStringFormat.secMs.msStr(timerVM.counter))
                    .font(.headline)
                    .bold()
                    .foregroundStyle(Color.green)
            }
        )
        .frame(width: 64)
    }
    
    private var dartsView: some View {
        ZStack {
            DartsTargetView(dartsTargetPalette: .classic)
                .environmentObject(dartsTargetVM)
                .overlay {
                    DartsHitsView()
                        .environmentObject(dartsHitsVM)
                }
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2), value: rotation)
                .opacity(dartsTargetSide1IsShow ? 1 : 0)
            
            DartsTargetView(dartsTargetPalette: .classic)
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
                    DartsGameAnswerView(score: answer) { onAnswered(answer) }
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
        print("DartsGameView.\(#function)")
        resetGame(isRestart: true)
    }
    
    private func resetGame(isRestart: Bool = false) {
        print("DartsGameView.\(#function)")
        if isRestart {
            gameVM.restart(appSettings: appSettingsVM.model)
        } else {
            gameVM.reset(appSettings: appSettingsVM.model)
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
            dartSize: appSettingsVM.model.dartSize,
            dartImageName: appSettingsVM.model.dartImageName
        )
        
//        dartsHitsVM.reset(
//            dartsWithMiss: gameVM.game.dartsWithMiss,
//            dartsSize: appSettingsVM.model.dartSize
//        )
        
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
        gameVM.generateAnswers(dartsHitsVM.score)
        answersIsShow = true
    }
    
    func playTimerSound() {
        SoundManager.shared.play(TimerEndSound())
//        print("DartsGameView.\(#function)")
//        let resourcePath = Bundle.main.url(forResource: "timer", withExtension: "mp3")
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: resourcePath!)
//            audioPlayer?.play()
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    func stopTimerSound() {
        SoundManager.shared.stop(TimerEndSound())
    }
    
    func playTapSound() {
        SoundManager.shared.play(UserTapSound())
    }
    
    private func onAnswered(_ answer: Int) {
        print("DartsGameView.\(#function)")
        
        if timerVM.isNotified {
            stopTimerSound()
        }
        
        playTapSound()
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
        print("DartsGameView.\(#function)")
        isDartsTargetSide1.toggle()
        rotation += Constants.rotationAngle
        
        SoundManager.shared.play(DartsRotationSound())
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
        print("DartsGameView.\(#function)")
        timerVM.stop()
        gameVM.stop()
        
//        resetGame()
    }
    
    private func finishGame() {
        print("DartsGameView.\(#function)")
        timerVM.stop()
        answersIsShow = false
    }
}

private struct TestDartsGameView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            DartsGameView()
            //appSettings: appSettingsVM.model)
                .environment(\.mainWindowSize, geometry.size)
                .environmentObject(appSettingsVM)
        }
    }
}

#Preview {
    TestDartsGameView()
}
