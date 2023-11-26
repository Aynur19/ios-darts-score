//
//  DartsGameAnswersView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

final class DartsGameAnswersViewModel: ObservableObject {
    @Published private(set) var model: DartsGameStats
    
    init(model: DartsGameStats) {
        self.model = model
    }
}

struct GameAnswersView: View {
    private let game: DartsGame
//    let game = MockData.getDartsGameStats().items[0]
    
    init(_ game: DartsGame) {
        self.game = game
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                TargetView(.init())
                    .overlay {
                        DartHitsView(game.answers[0].darts)
                    }
                
                HStack(spacing: 20) {
                    ForEach(game.answers[0].answers, id: \.self) { answer in
                        let answerColor = getAnswerColor(answer,
                                                         actual: game.answers[0].actual,
                                                         expected: game.answers[0].expected)
                        
                        GameAnswerView(answer, color: answerColor)
                    }
                }
            }
        }
        .navigationTitle("История игры: \(game.id)")
    }
    
    private func getAnswerColor(_ answer: Int, actual: Int, expected: Int) -> Color {
        if answer == expected {
            .green
        } else if answer == actual {
            .red
        } else {
            .blue
        }
    }
}

#Preview {
    GameAnswersView(MockData.getDartsGameStats().items[0])
}

//struct DartsGameAnswersView: View {
//    @ObservedObject var dartsVM = DartsViewModel()
//    @ObservedObject var gameAnswersVM: DartsGameAnswersViewModel
//    
//    var body: some View {
//        ZStack {
//            DartsTargetView(dartsVM)
//                .overlay {
//                    GeometryReader { geometry in
//                        let center = CGPoint.getCenter(from: geometry)
//                        
//                        
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    DartsGameAnswersView(gameAnswersVM: .init(model: MockData.getDartsGameStats()))
//}
