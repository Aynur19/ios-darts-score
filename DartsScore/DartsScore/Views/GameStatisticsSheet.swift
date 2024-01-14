//
//  GameStatisticsSheet.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 30.11.2023.
//

import SwiftUI
import SwiftUIComponents4iOS

private struct GameStatisticsSheetConstants {
    static let vSpacing: CGFloat = 16
}

struct GameStatisticsSheet: View {
    private typealias Constants = GameStatisticsSheetConstants
    
    private let game: DartsGame
    private let snapshots: DartsGameSnapshotsList
    
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    init(game: DartsGame, snapshots: DartsGameSnapshotsList) {
        self.game = game
        self.snapshots = snapshots
    }
    
    var body: some View {
        VStack {
            Text("sheetTitle_DetailedGameStats")
                .font(.title2)
                .padding()
            
            ScrollView {
                VStack {
                    gameStats
                    gameAnswersState
                }
            }
        }
    }
    
    // MARK: Game Stats
    private var gameStats: some View {
        HStack {
            gameStatsLabels
            Spacer()
            gameStatsValues
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(Palette.btnPrimary)
        .padding()
        .glowingOutline()
        .padding()
        .padding(.horizontal)
    }
    
    private var gameStatsLabels: some View {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
            Text("label_GameScore")
            Text("label_GameTime")
            Text("label_Attempts")
            Text("label_SuccessAnswers")
            Text("label_SkippedAnswers")
            Text("label_GameDate")
        }
    }
    
    private var gameStatsValues: some View {
        VStack(alignment: .trailing, spacing: Constants.vSpacing) {
            Text(String(game.score))
            Text("\(getTime(time: game.timeSpent)) suffix_Seconds")
            Text(String(game.attempts))
            Text(String(game.correct))
            Text(String(game.skipped))
            Text(dateTimeStr)
        }
    }
    
    // MARK: Game Answers Stats
    private var gameAnswersState: some View {
        ForEach(snapshots.snapshots) { snapshot in
            gameAnswerStats(snapshot, idx: snapshot.id)
        }
    }
    
    private func gameAnswerStats(_ snapshot: DartsGameSnapshot, idx: Int) -> some View {
        VStack {
            Text("label_Answer \(idx + 1)")
            HStack {
                gameAnswerStatsLabels(snapshot)
                Spacer()
                gameAnswerStatsValues(snapshot)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .glowingOutline(color: Palette.btnSecondary)
            .padding(.bottom)
            .padding(.horizontal)
            .padding(.horizontal)
        }
        .foregroundStyle(Palette.btnSecondary)
    }
    
    private func gameAnswerStatsLabels(_ snapshot: DartsGameSnapshot) -> some View {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
            Text("label_HitPoints")
            ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                Text("\tlabel_Hit \(dartIdx + 1) ")
            }
            Text("label_UserAnswer")
            Text("label_AnswerTimeSpent")
            Text("label_AnswerPoints")
        }
    }
    
    private func gameAnswerStatsValues(_ snapshot: DartsGameSnapshot) -> some View {
        VStack(alignment: .trailing, spacing: Constants.vSpacing) {
            Text(String(snapshot.expected))
            ForEach(snapshot.darts) { dart in
                getDartSectorDescription(sector: dart.sector)
            }
            
            getUserAnswer(userAnswer: snapshot.actual)
            Text("\(getTime(time: snapshot.time)) suffix_Seconds")
            Text(String(snapshot.score))
        }
    }
    
    private func getDartSectorDescription(sector: DartsSector) -> some View {
        sector.points > .zero ? Text(sector.description) : Text("label_Miss")
    }
    
    private func getUserAnswer(userAnswer: Int) -> some View {
        userAnswer >= .zero ? Text("\(userAnswer)") : Text("label_SkippedAnswer")
    }
    
    private func getTime(time: Int) -> String {
        TimerStringFormat.secMs.msStr(time)
    }
    
    private var dateTimeStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: game.dateTime)
    }
}

#Preview {
    GameStatisticsSheet(
        game: MockData.getDartsGameStats().items[0],
        snapshots: MockData.getDartsGameSnapshotsList()
    )
}
