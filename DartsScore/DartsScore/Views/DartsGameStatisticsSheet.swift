//
//  DartsGameStatisticsSheet.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 30.11.2023.
//

import SwiftUI

struct DartsGameStatisticsSheet: View {
    private let game: DartsGame
    private let snapshots: DartsGameSnapshotsList
    
    @StateObject var appSettings = AppSettingsVM.shared
    
    init(_ game: DartsGame, _ snapshots: DartsGameSnapshotsList) {
        self.game = game
        self.snapshots = snapshots
    }
    
    var body: some View {
        VStack {
            Text("sheetTitle_DetailedGameStats")
                .font(.title2)
                .padding(16)
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
            VStack(alignment: .leading, spacing: 16) {
                Text("label_GameScore")
                Text("label_GameTime")
                Text("label_Attempts")
                Text("label_SuccessAnswers")
                Text("label_GameDate")
            }
            
            Spacer()
            VStack(alignment: .trailing, spacing: 16) {
                Text(String(game.score))
                Text("\(appSettings.timerTextFormat.msStr(game.timeSpent)) suffix_Seconds")
                Text(String(game.attempts))
                Text(String(game.successAttempts))
                Text(dateTimeStr)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(Palette.btnPrimary)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Palette.btnPrimary, lineWidth: 2)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
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
                VStack(alignment: .leading, spacing: 16) {
                    Text("label_HitPoints")
                    ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                        Text("\tlabel_Hit \(dartIdx + 1) ")
                    }
                    Text("label_UserAnswer")
                    Text("label_AnswerTimeSpent")
                    Text("label_AnswerPoints")
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 16) {
                    Text(String(snapshot.expected))
                    ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                        let dart = snapshot.darts[dartIdx]
                        if dart.sector.points > 0 {
                            Text(dart.sector.description)
                        } else {
                            Text("label_Miss")
                        }
                    }
                    Text(String(snapshot.actual))
                    Text("\(appSettings.timerTextFormat.msStr(snapshot.time)) suffix_Seconds")
                    Text(String(snapshot.score))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Palette.btnSecondary, lineWidth: 2)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
        .foregroundStyle(Palette.btnSecondary)
    }
    
    private var dateTimeStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: game.dateTime)
    }
}

#Preview {
    DartsGameStatisticsSheet(MockData.getDartsGameStats().items[0],
                             MockData.getDartsGameSnapshotsList())
}
