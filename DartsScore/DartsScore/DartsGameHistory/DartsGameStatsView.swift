//
//  DartsGameStatsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameStatsViewConstants {
    static let chevronName = "chevron.right"
    static let hPadding: CGFloat = 32
    static let vPadding: CGFloat = 10
    static let rowCornerRadius: CGFloat = 20
}

final class DartsGameStatsViewModel: ObservableObject {
    @Published private(set) var model: DartsGameStats
    
    init() {
        model = DartsGameStatsViewModel.getModel()
    }
    
    func refresh() {
        model = DartsGameStatsViewModel.getModel()
    }
    
    private static func getModel() -> DartsGameStats {
        if isPreview {
            return MockData.getDartsGameStats()
        } else {
            return JsonCache.loadDartsGameStats(from: AppSettings.statsJsonFileName)
        }
    }
    
    func getGame(_ idx: String) -> DartsGame? {
        model.items.first { $0.id == idx }
    }
}

struct DartsGameStatsView: View {
    private typealias Constants = DartsGameStatsViewConstants
    
    @StateObject var appSettings = AppSettings.shared
    @StateObject var statsVM = DartsGameStatsViewModel()
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                appSettings.pallet.background
                    .ignoresSafeArea()
                
                VStack {
                    headers
                        .padding(.horizontal, Constants.hPadding)
                    statisticsList
                }
                .onAppear {
                    statsVM.refresh()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("viewTitle_Statistics")
                        .font(.title2)
                        .foregroundStyle(appSettings.pallet.bgTextColor)
                }
            }
            .navigationDestination(for: String.self) { gameIdx in
                if let game = statsVM.getGame(gameIdx) {
                    GameAnswersView(game, stats: MockData.getDartsGameSnapshotsList())
                }
            }
        }
    }
    
    private var headers: some View {
        HStack {
            Text("label_Score")
                .frame(maxWidth: .infinity)
            Text("label_Attempts")
                .frame(maxWidth: .infinity)
            Text("label_Time")
                .frame(maxWidth: .infinity)
        }
        .font(.headline)
        .foregroundStyle(appSettings.pallet.bgTextColor)
        .padding(.trailing, 32)
    }
    
    private var statisticsList: some View {
        ScrollView {
            ForEach(statsVM.model.items) { game in
                Button(action: {
                    path.append(game.id)
                }, label: {
                    row(game)
                })
                .foregroundStyle(Color.black)
                .padding(.horizontal, Constants.hPadding.half)
            }
        }.frame(maxWidth: .infinity)
    }
    
    private func row(_ game: DartsGame) -> some View {
        HStack {
            Text(String(game.score))
                .bold()
                .frame(maxWidth: .infinity)
            Text(attemptsStr(game.attempts, success: game.successAttempts))
                .frame(maxWidth: .infinity)
            Text("\(TimerStringFormat.secMs.msStr(game.timeSpent)) suffix_Seconds")
                .frame(maxWidth: .infinity)
            Image(systemName: Constants.chevronName)
        }
        .foregroundStyle(appSettings.pallet.btnPrimaryTextColor)
        .padding(.vertical, Constants.vPadding)
        .padding(.horizontal)
        .background(appSettings.pallet.btnPrimaryColor)
        .clipShape(RoundedRectangle(cornerRadius: Constants.rowCornerRadius))
    }
    
    private func attemptsStr(_ allAttempts: Int, success: Int) -> String {
        "\(success)/\(allAttempts)"
    }
}

#Preview {
    DartsGameStatsView()
}
