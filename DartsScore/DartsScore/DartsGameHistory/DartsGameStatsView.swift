//
//  DartsGameStatsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

//struct DartsGameHistoryView: View {
//    
//}

//class DartsGameStatsViewModel: ObservableObject {
//    @Published private(set) var stats: DartsGameStats
//    
//    init() {
////        stats = JsonCache.loadDartsGameStats(from: AppSettings.statsJsonFileName)
//        stats = MockData.getDartsGameStats()
//    }
//    
//    func refresh() {
////        stats = JsonCache.loadDartsGameStats(from: AppSettings.statsJsonFileName)
//        stats = MockData.getDartsGameStats()
//    }
//}

struct DartsGameStatsView: View {
    @State private var path = NavigationPath()
    @State private var stats: DartsGameStats = MockData.getDartsGameStats()
//    @ObservedObject var statsVM: DartsGameStatsViewModel
    
//    init(statsVM: DartsGameStatsViewModel = .init()) {
//        self.statsVM = statsVM
//        
//    }
//    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    HStack {
                        Text("Очки")
                            .bold()
                            .frame(maxWidth: .infinity)
                        Text("Попытки")
                            .frame(maxWidth: .infinity)
                        Text("Время")
                            .frame(maxWidth: .infinity)
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 32)
                    
                    ForEach(stats.items) { game in
                        Button(action: {
                            path.append(game.id)
                        }, label: {
                            HStack {
                                Text(String(game.score))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                Text("\(game.successAttempts)/\(game.attempts)")
                                    .frame(maxWidth: .infinity)
                                Text("\(game.timeForAnswer) сек.")
                                    .frame(maxWidth: .infinity)
                                Image(systemName: "chevron.right")
                            }
                        })
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 4)
                    }
                }.frame(maxWidth: .infinity)
                
//                VStack {
//                    HStack {
//                        Text("Очки")
//                        Spacer()
//                        Text("Попытки")
//                        Spacer()
//                        Text("Время на ответ")
//                    }
//                    .padding(.horizontal, 32)
                    
//                    Table(statsVM.model.items) {
//                        TableColumn("Очки") { item in
//                            Text(String(item.score))
//                        }
//                        TableColumn("Очки2") { item in
//                            Text(String(item.attempts))
//                        }
//                    }
//                    Table(statsVM.model.items) {
////                        TableColumn("Очки") { item in
////                            Text(String(item.score))
////                        }
//                        
//                        TableColumn("Попытки") { item2 in
//                            Text("\(item2.successCount)")
//                        }
//                    }
//                    List(statsVM.model.items) { gameStats in
//                        HStack {
//                            Text(String(gameStats.score))
//                            Spacer()
//                            Text("\(gameStats.successCount)/\(gameStats.attempts)")
//                            Spacer()
//                            Spacer()
//                            Text("\(gameStats.timeForAnswer) сек.")
//                        }
//                    }
//                }
                .onAppear {
                    refresh()
                }
            }
            .navigationTitle("Статистика")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { gameIdx in
                if let game = getGame(gameIdx) {
                    GameAnswersView(game, stats: MockData.getDartsGameSnapshotsList())
//                    GameAnswersView(game)
                }
//                if view == "NewView" {
//                    Text("This is NewView")
//                }
            }
        }
    }
    
    private func refresh() {
        stats = MockData.getDartsGameStats()
    }
    
    private func getGame(_ idx: String) -> DartsGame? {
        stats.items.first { $0.id == idx }
    }
}

//#Preview {
//    NavigationStack {
//        DartsGameStatsView()
//    }
//}

