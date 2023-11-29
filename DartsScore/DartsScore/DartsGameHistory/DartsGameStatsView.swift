//
//  DartsGameStatsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameStatsViewConstants {
    static let title = "Статистика"
    static let pointsLabel = "Очки"
    static let attemptsLabel = "Попытки"
    static let timeLabel = "Время"
    
    static let chevronName = "chevron.right"
}

struct DartsGameStatsView: View {
    private typealias Constants = DartsGameStatsViewConstants
    
    @State private var path = NavigationPath()
    @State private var stats: DartsGameStats = MockData.getDartsGameStats()
    
    @StateObject var appSettings = AppSettings.shared
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                appSettings.pallet.background
                    .ignoresSafeArea()
                
                VStack {
                    headers
                        .padding(.horizontal, 32)
                    ScrollView {
                        
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
                }
                .onAppear {
                    refresh()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    viewTitle(Constants.title)
                }
            }
//            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .navigationBar)
//            .toolbarColorScheme(.light, for: .navigationBar)
//            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: String.self) { gameIdx in
                if let game = getGame(gameIdx) {
                    GameAnswersView(game, stats: MockData.getDartsGameSnapshotsList())
                }
            }
        }
    }
    
    private var headers: some View {
        HStack {
            label(Constants.pointsLabel)
                .frame(maxWidth: .infinity)
            label(Constants.attemptsLabel)
                .frame(maxWidth: .infinity)
            label(Constants.timeLabel)
                .frame(maxWidth: .infinity)
        }
        .padding(.trailing, 32)
    }
    
    private func row(_ game: DartsGame) -> some View {
        HStack {
            Text(String(game.score))
                .frame(maxWidth: .infinity)
            Text(attemptsStr(game.attempts, success: game.successAttempts))
                .frame(maxWidth: .infinity)
            Text(timeStr(game.timeForAnswer))
                .frame(maxWidth: .infinity)
            Image(systemName: Constants.chevronName)
        }
        .foregroundStyle(appSettings.pallet.btnPrimaryTextColor)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(appSettings.pallet.btnPrimaryColor)
        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
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

