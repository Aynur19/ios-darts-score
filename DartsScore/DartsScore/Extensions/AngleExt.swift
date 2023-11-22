//
//  AngleExt.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

extension Angle {
    static var circle: Self { .degrees(360) }
    
    static func circleSector(devided by: Double) -> Self {
        .degrees(360 / by)
    }
    
    static func randomCircleSector() -> Self {
        .degrees(Double.random(in: 0...360))
    }
    
    static func trigonometric(at point: CGPoint) -> Self {
        .degrees(atan2(point.y, point.x))
    }
    
    var trigonometric: Self {
        return self.degrees > .zero
        ? .degrees(self.degrees * 180 / .pi)
        : .init(degrees: 360 + CGFloat(self.degrees * 180 / .pi))
    }
}
