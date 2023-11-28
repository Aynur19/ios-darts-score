//
//  DartsGameStatsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameStatsViewConstants {
    static let pointsLabel = "Очки"
    static let attemptsLabel = "Попытки"
    static let timeLabel = "Время"
    
    static let chevronName = "chevron.right"
}

struct DartsGameStatsView: View {
    private typealias Constants = DartsGameStatsViewConstants
    
    @State private var path = NavigationPath()
    @State private var stats: DartsGameStats = MockData.getDartsGameStats()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.offWhite.ignoresSafeArea(.all)
                
                ScrollView {
                    headers
                        .padding(.horizontal, 32)
                    
                    ForEach(stats.items) { game in
                        Button(action: {
                            path.append(game.id)
                        }, label: {
                            row(game)
                                
                        })
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 16)
//                        .padding(.vertical, 4)
                    }
                }.frame(maxWidth: .infinity)
                .onAppear {
                    refresh()
                }
            }
            .navigationTitle("Статистика")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { gameIdx in
                if let game = getGame(gameIdx) {
                    GameAnswersView(game, stats: MockData.getDartsGameSnapshotsList())
                }
            }
        }
    }
    
    private var headers: some View {
        HStack {
            Text(Constants.pointsLabel)
                .bold()
                .frame(maxWidth: .infinity)
            Text(Constants.attemptsLabel)
                .frame(maxWidth: .infinity)
            Text(Constants.timeLabel)
                .frame(maxWidth: .infinity)
            Spacer(minLength: 32)
        }
    }
    
    private func row(_ game: DartsGame) -> some View {
        HStack {
            Text(String(game.score))
                .bold()
                .frame(maxWidth: .infinity)
            Text(attemptsStr(game.attempts, success: game.successAttempts))
                .frame(maxWidth: .infinity)
            Text(timeStr(game.timeForAnswer))
                .frame(maxWidth: .infinity)
            Image(systemName: Constants.chevronName)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.offWhite)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//        .shadow(color: .gray, radius: 5)
    }
    
    private func attemptsStr(_ allAttempts: Int, success: Int) -> String {
        "\(success)/\(allAttempts)"
    }
    
    private func timeStr(_ time: Int) -> String {
        TimerStringFormat.secMs.msStr(time) + " сек."
    }
    
    private func refresh() {
        stats = MockData.getDartsGameStats()
    }
    
    private func getGame(_ idx: String) -> DartsGame? {
        stats.items.first { $0.id == idx }
    }
}

#Preview {
    DartsGameStatsView()
}

