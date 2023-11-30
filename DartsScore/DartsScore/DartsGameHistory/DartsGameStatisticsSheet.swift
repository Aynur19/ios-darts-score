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
    
    @StateObject var appSettings = AppSettings.shared
    
    init(_ game: DartsGame, _ snapshots: DartsGameSnapshotsList) {
        self.game = game
        self.snapshots = snapshots
    }
    
    var body: some View {
        VStack {
            Text("sheetTitle_DetailedGameStats")// "Подробная статистика игры"
                .font(.title2)
                .padding(16)
            ScrollView {
                VStack {
                    
                    gameStats
                    gameAnswersState
//                    gameAnswerStats(snapshots.snapshots[0], idx: 1)
                    //            appSettings.palette.background
                    //                .opacity(0.1)
                    //                .blur(radius: 3.0)
                    //                .ignoresSafeArea()
                }
            }
        }
    }
    
    private var gameStats: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("label_GameScore")// "Очков за игру: "
                Text("label_GameTime")// "Общее время: "
                Text("label_Attempts")// "Всего попыток: "
                Text("label_SuccessAnswers")// "Правильных ответов: "
                Text("label_GameDate")// "День игры: "
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
        .foregroundStyle(appSettings.palette.btnPrimaryColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(appSettings.palette.btnPrimaryColor, lineWidth: 2)
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
            Text("label_Answer \(idx + 1)")// "Ответ "
//
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("label_HitPoints")// "Очки попадания: "
                    ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                        Text("\tlabel_Hit \(dartIdx + 1) ") // "Попадание"
                    }
                    Text("label_UserAnswer")// "Ответ пользователя: "
                    Text("label_AnswerTimeSpent")// "Затрачено времени: "
                    Text("label_AnswerPoints")// "Очки за ответ: "
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 16) {
                    Text(String(snapshot.expected))
                    ForEach(snapshot.darts.indices, id: \.self) { dartIdx in
                        let dart = snapshot.darts[dartIdx]
                        if dart.sector.points > 0 {
                            Text(dart.sector.description)
                        } else {
                            Text("label_Miss")// "промах"
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
                    .stroke(appSettings.palette.btnSecondaryColor, lineWidth: 2)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
        .foregroundStyle(appSettings.palette.btnSecondaryColor)
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
