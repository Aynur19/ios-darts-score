//
//  DartsGameAnswerView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

private struct DartsGameAnswerViewConstants {
    static let frameSize: CGFloat = 60
    static let shadowRadius: CGFloat = 4
    static let lineWidth: CGFloat = 4
    static let color = Color(UIColor(red: 1, green: 0.84, blue: 0.41, alpha: 1))// Color(UIColor(red: 1, green: 0.61, blue: 0.2, alpha: 1))
}

struct DartsGameAnswerView: View {
    private typealias Constants = DartsGameAnswerViewConstants
    
    let score: Int
    let color: Color
    let onAnswered: () -> Void
    
    init(
        _ score: Int,
        color: Color = Constants.color,
        onAnswered: @escaping () -> Void = { }
    ) {
        self.score = score
        self.color = color
        self.onAnswered = onAnswered
    }
    
    var body: some View {
        Button(action: onAnswered) {
            Circle()
                .stroke(lineWidth: Constants.lineWidth)
                .frame(width: Constants.frameSize)
                .shadow(radius: Constants.shadowRadius)
                .overlay {
                    Text(String(score))
                }
        }
        .foregroundColor(color)
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}

#Preview {
    DartsGameAnswerView(180)
}