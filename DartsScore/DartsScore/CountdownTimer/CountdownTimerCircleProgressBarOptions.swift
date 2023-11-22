//
//  CountdownTimerCircleProgressBarOptions.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

struct CountdownTimerCircleProgressBarOptions {
    let circleLineWidth: CGFloat
    
    let circleDownColor: Color
    let ciclreDownOpacity: CGFloat
    
    let circleUpColor: Color
    let ciclreUpOpacity: CGFloat
    let circleUpRotation: Angle
    
    let animationDuration: CGFloat
    let textFont: Font
    let textColor: Color
    let textIsBold: Bool
    let textFormat: TimerStringFormat
    
    init(
        circleLineWidth: CGFloat = 20,
        circleDownColor: Color = .gray,
        ciclreDownOpacity: CGFloat = 0.3,
        circleUpColor: Color = .green,
        ciclreUpOpacity: CGFloat = 1.0,
        circleUpRotation: Angle = .degrees(-90),
        animationDuration: CGFloat = 0.2,
        textFont: Font = .title,
        textColor: Color = .green,
        textIsBold: Bool = true,
        textFormat: TimerStringFormat = .secMs
    ) {
        self.circleLineWidth = circleLineWidth
        self.circleDownColor = circleDownColor
        self.ciclreDownOpacity = ciclreDownOpacity
        self.circleUpColor = circleUpColor
        self.ciclreUpOpacity = ciclreUpOpacity
        self.circleUpRotation = circleUpRotation
        self.animationDuration = animationDuration
        self.textFont = textFont
        self.textColor = textColor
        self.textIsBold = textIsBold
        self.textFormat = textFormat
    }
}
