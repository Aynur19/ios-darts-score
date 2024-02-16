//
//  GameAnswersListView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 26.12.2023.
//

import SwiftUI

struct GameAnswersListView: View {
    private let answers: [Int]
    private let onAnswered: (Int) -> Void
    
    init(
        answers: [Int],
        onAnswered: @escaping (Int) -> Void
    ) {
        self.answers = answers
        self.onAnswered = onAnswered
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("label_HowHitPoins")
                .font(.headline)
                .foregroundStyle(Palette.bgText)
            
            HStack(spacing: 10) {
                ForEach(answers, id: \.self) { answer in
                    GameAnswerView(
                        score: answer,
                        onAnswered: { onAnswered(answer) }
                    )
                }
            }
        }
    }
}


// MARK: Preview
private struct TestGameAnswersListView: View {
    @State private var answers = [Int]()
    @State private var message = ""
    
    var body: some View {
        VStack {
            Spacer()
            GameAnswersListView(answers: answers) { answer in
                updateMessage(answer: answer)
            }
            
            Spacer()
            Text(message)
            Spacer()
            
            Button(
                action: { updateAnswers() },
                label: { Text("UPDATE ANSWERS") }
            )
            Spacer()
        }
    }
    
    private func updateMessage(answer: Int) {
        message = "Last Answer: \(answer)"
    }
    
    private func updateAnswers() {
        answers.removeAll()
        
        for _ in 0..<5 {
            answers.append(Int.random(in: 0...180))
        }
    }
}

#Preview { TestGameAnswersListView() }
