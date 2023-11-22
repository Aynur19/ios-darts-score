//
//  CountdownTimerViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

enum CountdownTimerState: String {
    case idle
    case stoped
    case processing
    case finished
}

private struct CountdownTimerViewModelConstants {
    static let progressFull: CGFloat = 1
    static let restartSleep: UInt64 = .nanoseconds(from: 1)
    static let timerInterval: Double = 0.1
    static let counterChangeValue: Int = 100
}

class CountdownTimerViewModel: ObservableObject {
    private typealias Constants = CountdownTimerViewModelConstants
    
    @Published private(set) var progress: CGFloat = Constants.progressFull
    @Published private(set) var counter: Int = .zero
    @Published private(set) var timeOfMs: Int = .zero
    @Published private(set) var state: CountdownTimerState = .idle
    
    private var timer: Timer?

    init(_ seconds: Int? = .none) {
        reset(seconds)
    }
    
    func reset(_ seconds: Int?) {
        timer?.invalidate()
        if let seconds = seconds {
            timeOfMs = seconds.secToMs
        }
        counter = timeOfMs
        progress = Constants.progressFull
        state = .idle
    }
    
    func start(_ seconds: Int?) {
        reset(seconds)
        startTimer()
    }
    
    func stop() {
        stopTimer()
    }
    
    func resume() {
        startTimer()
    }
    
    private func restartTimer() {
        progress = Constants.progressFull
        counter = timeOfMs
        
        Task {
            timer?.invalidate()

            if timer != nil {
                try? await Task.sleep(nanoseconds: Constants.restartSleep)
            }
            
            await MainActor.run {
                progress = getProgress()
                startTimer()
            }
        }
    }
    
    private func resumeTimer() {
        timer?.invalidate()
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.counter > .zero {
                self.counter -= Constants.counterChangeValue
                self.progress = self.getProgress()
            } else {
                self.state = .finished
            }
        }
        
        state = .processing
    }
    
    private func stopTimer() {
        timer?.invalidate()
        state = .stoped
    }
    
    private func getProgress() -> CGFloat {
        CGFloat(counter) / CGFloat(timeOfMs)
    }
    
    deinit {
        timer?.invalidate()
    }
}
