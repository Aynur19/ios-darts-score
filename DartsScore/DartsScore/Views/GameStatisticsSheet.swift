//
//  GameStatisticsSheet.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 30.11.2023.
//

import SwiftUI

private struct GameStatisticsSheetConstants {
    static let vSpacing: CGFloat = 16
}

struct GameStatisticsSheet: View {
    private typealias Constants = GameStatisticsSheetConstants
    
    private let game: DartsGame
    private let snapshots: DartsGameSnapshotsList
    
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    init(_ game: DartsGame, _ snapshots: DartsGameSnapshotsList) {
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
    
    private var gameStats: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.vSpacing) {
                Text("label_GameScore")
                Text("label_GameTime")
                Text("label_Attempts")
                Text("label_SuccessAnswers")
                Text("label_SkippedAnswer")
                Text("label_GameDate")
            }
            
            Spacer()
            VStack(alignment: .trailing, spacing: Constants.vSpacing) {
                Text(String(game.score))
                Text("\(getTime(time: game.timeSpent)) suffix_Seconds")
                Text(String(game.attempts))
                Text(String(game.correct))
                Text(String(game.missed))
                Text(dateTimeStr)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(Palette.btnPrimary)
        .padding()
        .glowingOutline()
        .padding()
        .padding(.horizontal)
    }
    
    private var gameAnswersState: some View {
        ForEach(snapshots.snapshots) { snapshot in
            gameAnswerStats(snapshot, idx: snapshot.id)
        }
    }
    
    private func gameAnswerStats(_ snapshot: DartsGameSnapshot, idx: Int) -> some View {
        VStack {
            Text("label_Answer \(idx + 1)")
            HStack {
                VStack(alignment: .leading, spacing: Constants.vSpacing) {
                    Text("label_HitPoints")
                    ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                        Text("\tlabel_Hit \(dartIdx + 1) ")
                    }
                    Text("label_UserAnswer")
                    Text("label_AnswerTimeSpent")
                    Text("label_AnswerPoints")
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: Constants.vSpacing) {
                    Text(String(snapshot.expected))
                    ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                        let dart = snapshot.darts[dartIdx]
                        if dart.sector.points > .zero {
                            Text(dart.sector.description)
                        } else {
                            Text("label_Miss")
                        }
                    }
                    if snapshot.actual >= .zero {
                        Text(String(snapshot.actual))
                    } else {
                        Text("label_SkippedAnswer")
                    }
                    Text("\(getTime(time: snapshot.time)) suffix_Seconds")
                    Text(String(snapshot.score))
                }
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
    
    private func getTime(time: Int) -> String {
        AppConstants.timerTextFormat.msStr(time)
    }
    
    private var dateTimeStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: game.dateTime)
    }
}

#Preview {
    GameStatisticsSheet(MockData.getDartsGameStats().items[0],
                             MockData.getDartsGameSnapshotsList())
}
