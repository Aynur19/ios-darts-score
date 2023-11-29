//
//  DartsGameAnswersView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

//final class DartsGameAnswersViewModel: ObservableObject {
//    @Published private(set) var model: DartsGameStats
//    
//    init(model: DartsGameStats) {
//        self.model = model
//    }
//}

struct GameAnswersView: View {
    private let game: DartsGame
    private let stats: DartsGameSnapshotsList
    
    @StateObject var appSettings = AppSettings.shared
    @State private var index = 0
    
    init(_ game: DartsGame, stats: DartsGameSnapshotsList) {
        self.game = game
        self.stats = stats
    }
    
    var body: some View {
        ZStack {
            appSettings.pallet.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                TabView(selection: $index) {
                    ForEach(stats.snapshots) { snapshot in
                        VStack(spacing: 60) {
                            DartsTargetView(.init(.shared), appSettings: .shared)
                                .overlay { DartsHitsView(snapshot.darts, appSettings: .shared) }
                            
                            HStack {
                                ForEach(snapshot.answers, id: \.self) { answer in
                                    let answerColor = getAnswerColor(answer,
                                                                     actual: snapshot.actual,
                                                                     expected: snapshot.expected)
    
                                    DartsGameAnswerView(answer, color: answerColor)
                                }
                            }.padding(.horizontal, 16)
                            
                            HStack {
                                ForEach(snapshot.darts) { dart in
                                    Text(dart.sector.description)
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                
                HStack(spacing: 4) {
                    ForEach(0..<stats.snapshots.count, id: \.self) { index in
                        Circle()
                            .fill(getTabIndexColor(index))
                            .frame(width: 12)

                    }
                }
                .padding()
//                DartsTargetView(.init())
//                    .overlay {
//                        DartsHitsView(game.answers[0].darts, appSettings: .shared)
//                    }
                

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
    
    private func getTabIndexColor(_ index: Int) -> Color {
        self.index == index ? .blue : .blue.opacity(0.5)
    }
}

#Preview {
    GameAnswersView(MockData.getDartsGameStats().items[0],
                    stats: MockData.getDartsGameSnapshotsList())
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
