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

final class CountdownTimerViewModel: ObservableObject {
    @Published private(set) var progress: CGFloat = 1
    @Published private(set) var counter: Int
    @Published private(set) var time: Int
    @Published private(set) var state: CountdownTimerState = .idle
    
    @Published private(set) var isNotified = false
    private var timeLeftToNotify: Int
    
    private var timer: Timer?

    init(_ milliseconds: Int, timeLeftToNotify: Int = .max) {
        self.time = milliseconds
        self.timeLeftToNotify = timeLeftToNotify
        self.counter = milliseconds
    }
    
    func reset(_ milliseconds: Int? = .none, timeLeftToNotify: Int? = .none) {
        timer?.invalidate()
        if let timeOfMs = milliseconds {
            time = timeOfMs
        }
        
        if let timeLeftToNotifyOfMs = timeLeftToNotify {
            self.timeLeftToNotify = timeLeftToNotifyOfMs
        }
        
        isNotified = false
        
        counter = time
        progress = 1
        state = .idle
    }
    
    func start() {
        if let isValid = timer?.isValid, isValid { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.counter > .zero {
                tick()
            } else {
                finish()
            }
        }
        
        state = .processing
    }
    
    func stop() {
        timer?.invalidate()
        state = .stoped
    }
    
    private func tick() {
        counter -= 100
        
        if !isNotified, counter < timeLeftToNotify {
            isNotified = true
        }
        
        progress = CGFloat(counter) / CGFloat(time)
    }
    
    private func finish() {
        self.timer?.invalidate()
        self.state = .finished
    }
    
    deinit { timer?.invalidate() }
}
