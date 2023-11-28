//
//  DartsGameView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameViewConstants {
    static let title = "Дартс"
    static let attemptsRemainingLabel = "Осталось попыток: "
    static let opacityAnimationDuration: CGFloat = 0.5
    static let darts3DRotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 1, z: 0)
    static let background = Color(UIColor(red: 0.11, green: 0.72, blue: 1, alpha: 1))
    //Color = Color(UIColor(red: 0.34, green: 0.43, blue: 0.9, alpha: 1))
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
    
    @State private var topViewIsShow = false
    @State private var dartsTargetIsShow = false
    @State private var dartsTargetSide1IsShow = false
    @State private var dartsTargetSide2IsShow = false
    
    @State private var answersIsShow = false
    @State private var gameOverViewIsShow = false
    
    @State private var startBtnIsShow = false
    @State private var resumeBtnIsShow = false
    @State private var restartBtnIsShow = false
    
    init(_ appSettings: AppSettings = .shared) {
        self.appSettings = appSettings
        
        timerOptions = CountdownTimerCircleProgressBarOptions(
            circleLineWidth: appSettings.timerCircleLineWidth,
            circleDownColor: appSettings.timerCircleDownColor,
            ciclreDownOpacity: appSettings.timerCiclreDownOpacity,
            circleUpColor: Color(UIColor.systemIndigo),// appSettings.timerCircleUpColor,
            ciclreUpOpacity: appSettings.timerCiclreUpOpacity,
            circleUpRotation: appSettings.timerCircleUpRotation,
            animationDuration: appSettings.timerAnimationDuration,
            textFont: appSettings.timerTextFont,
            textColor: appSettings.timerTextColor,
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
                appSettings.pallet.background.ignoresSafeArea()
                
                VStack {
                    topView
                    dartsView
                        .frame(width: appSettings.dartsFrameWidth,
                               height: appSettings.dartsFrameWidth)
                        .opacity(dartsTargetIsShow ? 1 : 0)
                        .animation(.linear(duration: Constants.opacityAnimationDuration),
                                   value: dartsTargetIsShow)
                    
                    VStack {
                        gameOverView
                        answers
                        Spacer()
                    }
                }
                .padding()
                    
                VStack {
                    Spacer(minLength: 600)
                    startButton
                    resumeButton
                    restartButton
                    Spacer()
                }.padding(.horizontal, 64)
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
        .background()
    }
    
    private var topView: some View {
        HStack {
            attemptsLabel
            Spacer()
            CountdownTimerCircleProgressBar(timerVM: timerVM, options: timerOptions)
                .frame(width: 64)
        }
        .padding(.horizontal, 32)
        .opacity(topViewIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: topViewIsShow)
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
                .rotation3DEffect(.degrees(180), axis: Constants.darts3DRotationAxis)
                .rotation3DEffect(.degrees(rotation), axis: Constants.darts3DRotationAxis)
                .animation(.linear(duration: Constants.opacityAnimationDuration.x2),
                           value: rotation)
                .opacity(dartsTargetSide2IsShow ? 1 : 0)
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
        .opacity(answersIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: answersIsShow)
    }
    
    private var startButton: some View {
        PrimaryButton("НАЧАТЬ") { startGame() }
            .opacity(startBtnIsShow ? 1 : 0)
            .animation(.linear(duration: Constants.opacityAnimationDuration), value: startBtnIsShow)
    }
    
    private var resumeButton: some View {
        PrimaryButton("ПРОДОЛЖИТЬ") { startGame() }
            .opacity(resumeBtnIsShow ? 1 : 0)
            .animation(.linear(duration: Constants.opacityAnimationDuration), value: resumeBtnIsShow)
    }
    
    private var restartButton: some View {
        PrimaryButton("ЗАНОВО") { restartGame() }
            .opacity(restartBtnIsShow ? 1 : 0)
            .animation(.linear(duration: Constants.opacityAnimationDuration), value: restartBtnIsShow)
    }
    
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Text("Всего попыток: \(gameVM.game.attempts)")
            Text("Правильных ответов: \(gameVM.game.successAttempts)")
            Text("Заработано очков: \(gameVM.game.score)")
            Text("Затрачено времени: \(TimerStringFormat.secMs.msStr( gameVM.game.timeSpent))")
        }
        .font(.title2)
        .opacity(gameOverViewIsShow ? 1 : 0)
        .animation(.linear(duration: Constants.opacityAnimationDuration), value: gameOverViewIsShow)
    }
    
    private var attemptsLabel: some View {
        label("\(Constants.attemptsRemainingLabel) \(gameVM.remainingAttempts)")
    }
}

extension DartsGameView {
    private func restartGame() {
        resetGame(isRestart: true)
    }
    
    private func resetGame(isRestart: Bool = false) {
        gameVM.reset(isRestart: isRestart)
        dartsHitsVM.reset()
        timerVM.reset(appSettings.timeForAnswer)
        
        answersIsShow = false
        showDartsSide()
        topViewIsShow = true
        dartsTargetIsShow = true
        
        gameOverViewIsShow = false
        
        startBtnIsShow = gameVM.state == .idle
        resumeBtnIsShow = gameVM.state == .stoped
        restartBtnIsShow = gameVM.state == .stoped
    }
    
    private func startGame() {
        gameVM.start()
        timerVM.start(appSettings.timeForAnswer)
        
        updateAnswers()
        startBtnIsShow = false
        resumeBtnIsShow = false
        restartBtnIsShow = false
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
//        gameVM.onAnswered(
//            answer,
//            expectedScore: dartsHitsVM.score,
//            time: timerVM.counter,
//            darts: dartsHitsVM.darts
//        )
        
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
        dartsTargetIsShow = false
        topViewIsShow = false
        
        gameOverViewIsShow = true
        
        startBtnIsShow = false
        resumeBtnIsShow = false
        restartBtnIsShow = false
    }
}

#Preview {
    DartsGameView()
}
