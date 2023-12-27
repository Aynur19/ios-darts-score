//
//  TimerStringFormat.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

enum TimerStringFormat {
    case milliseconds
    case seconds
    case minutes
    case hours
    case secMs
    case minSec
    case hourMin
    case minSecMs
    case hourMinSec
    case hourMinSecMs
    
    func msStr(_ milliseconds: Int) -> String {
        let seconds = Int(milliseconds.msToSec)
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let fraction = milliseconds / 100
        
        switch self {
            case .milliseconds:     return .init(fraction)
            case .seconds:          return .init(seconds)
            case .minutes:          return .init(minutes)
            case .hours:            return .init(hours)
            case .secMs:            return .init(format: "%01d.%01d", seconds, fraction % 10)
            case .minSec:           return .init(format: "%01d.%02d", minutes, seconds % 60)
            case .hourMin:          return .init(format: "%01d.%02d", hours, minutes % 60)
            case .minSecMs:         return .init(format: "%01d:%02d.%01d", minutes, seconds % 60, fraction % 10)
            case .hourMinSec:       return .init(format: "%01d:%02d.%01d", hours, minutes % 60, seconds % 60)
            case .hourMinSecMs:     return .init(format: "%01d:%02d:%02d.%01d",
                                                 hours, minutes % 60, seconds % 60, fraction % 10)
        }
    }
}
