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
    @Published private(set) var time: Int = .zero
    @Published private(set) var state: CountdownTimerState = .idle
    
    private var timer: Timer?

    init(_ milliseconds: Int? = .none) {
        reset(milliseconds)
    }
    
    func reset(_ milliseconds: Int?) {
        timer?.invalidate()
        if let timeOfMs = milliseconds {
            time = timeOfMs
        }
        counter = time
        progress = Constants.progressFull
        state = .idle
    }
    
    func start(_ milliseconds: Int?) {
        reset(milliseconds)
        startTimer()
    }
    
    func stop() {
        stopTimer()
    }
    
    func resume() {
        startTimer()
    }
    
//    private func restartTimer() {
//        progress = Constants.progressFull
//        counter = time
//        
//        Task {
//            timer?.invalidate()
//
//            if timer != nil {
//                try? await Task.sleep(nanoseconds: Constants.restartSleep)
//            }
//            
//            await MainActor.run {
//                progress = getProgress()
//                startTimer()
//            }
//        }
//    }
    
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
        CGFloat(counter) / CGFloat(time)
    }
    
    deinit {
        timer?.invalidate()
    }
}
