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
    @Published private(set) var counter: Int
    @Published private(set) var time: Int
    @Published private(set) var state: CountdownTimerState = .idle
    
    @Published private(set) var isNotified = false
    private var timeLeftToNotify: Int
    
    private var timer: Timer?

    init(_ milliseconds: Int, timeLeftToNotify: Int = .max) {
        print("CountdownTimerViewModel.\(#function)")
        self.time = milliseconds
        self.timeLeftToNotify = timeLeftToNotify
        self.counter = milliseconds
    }
    
    func reset(_ milliseconds: Int? = .none, timeLeftToNotify: Int? = .none) {
        print("CountdownTimerViewModel.\(#function)")
        timer?.invalidate()
        if let timeOfMs = milliseconds {
            time = timeOfMs
        }
        
        if let timeLeftToNotifyOfMs = timeLeftToNotify {
            self.timeLeftToNotify = timeLeftToNotifyOfMs
        }
        
        isNotified = false
        
        counter = time
        progress = Constants.progressFull
        state = .idle
    }
    
    func start() {
        startTimer()
    }
    
    func stop() {
        stopTimer()
    }
    
    func resume() {
        startTimer()
    }
    
    private func resumeTimer() {
        print("CountdownTimerViewModel.\(#function)")
        timer?.invalidate()
        startTimer()
    }
    
    private func startTimer() {
        print("CountdownTimerViewModel.\(#function)")
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.counter > .zero {
                self.counter -= Constants.counterChangeValue
                
                if !self.isNotified, self.counter < timeLeftToNotify {
                    isNotified = true
                }
                self.progress = self.getProgress()
            } else {
                self.state = .finished
            }
        }
        
        state = .processing
    }
    
    private func stopTimer() {
        print("CountdownTimerViewModel.\(#function)")
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
