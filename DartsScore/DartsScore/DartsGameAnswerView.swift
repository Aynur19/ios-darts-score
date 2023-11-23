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
}

struct DartsGameAnswerView: View {
    private typealias Constants = DartsGameAnswerViewConstants
    
    let score: Int
    let onAnswered: () -> Void
    
    var body: some View {
        Button(action: onAnswered) {
            Circle()
                .stroke(Color.blue, lineWidth: Constants.lineWidth)
                .frame(width: Constants.frameSize)
                .shadow(radius: Constants.shadowRadius)
                .overlay {
                    Text(String(score))
                }
        }
        .transaction { transaction in
            transaction.animation = nil
        }
//        .animation(nil)
    }
}

#Preview {
    DartsGameAnswerView(score: 180) { }
}
