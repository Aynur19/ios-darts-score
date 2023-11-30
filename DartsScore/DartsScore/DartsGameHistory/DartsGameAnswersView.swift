//
//  DartsGameAnswersView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

final class GameSnapshotsViewModel: ObservableObject {
    let game: DartsGame
    let model: DartsGameSnapshotsList
    
    init(_ game: DartsGame) {
        self.game = game
        self.model = GameSnapshotsViewModel.getModel(game)
    }
    
    private static func getModel(_ game: DartsGame) -> DartsGameSnapshotsList {
        if isPreview {
            return MockData.getDartsGameSnapshotsList()
        }
        
        return JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
    }
}

struct GameAnswersView: View {
    @StateObject var appSettings = AppSettings.shared
    @ObservedObject var snapshotsVM: GameSnapshotsViewModel
    @State private var index = 0
    @State private var detailsIsShowed = false
    
    init(_ game: DartsGame, stats: DartsGameSnapshotsList) {
        snapshotsVM = .init(game)
    }
    
    var body: some View {
        ZStack {
            appSettings.palette.background
                .ignoresSafeArea()
            
            VStack {
//                Spacer()
//                gameStatsView
                
                Text("Ответ: 1")
                    .font(.headline)
                    .bold()
                
                snapshotsView
//                    .background(Color.red)
                
                snapshotsIndexView
                Spacer(minLength: 64)
//                    .frame(maxWidth: .infinity)
//                Spacer()
                Button {
                    detailsIsShowed = true
                } label: {
                    Text("Подробно")
                }
                
                Spacer(minLength: 32)
                
//                .frame(maxHeight: .infinity)
            }
            .blurredSheet(.init(.ultraThinMaterial), show: $detailsIsShowed) {
                
            } content: {
//                Text("Hello, World!")
                DartsGameStatisticsSheet(snapshotsVM.game, snapshotsVM.model)
                    .presentationDetents([.medium, .fraction(0.95)])
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("viewTitle_AnswersHistory")
                    .font(.title2)
                    .foregroundStyle(appSettings.palette.bgTextColor)
            }
        }//, onDissmiss: <#T##() -> ()#>, content: <#T##() -> View#>)
//        .sheet(isPresented: $detailsIsShowed) {
//            gameStatsView
//            DartsGameStatisticsSheet(snapshotsVM.game, snapshotsVM.model)
//                .presentationBackground(.ultraThinMaterial)
//                .presentationBackground(appSettings.palette.background.opacity(0.1))
//                .presentationBackground {
//                    appSettings.palette.background
//                        .opacity(0.1)
//                        .ignoresSafeArea()
//                }
                
//        }
    }
    
    private var gameStatsView: some View {
        VStack(spacing: 8) {
            Text("Очков за игру: ")
            Text("Общее время: ")
            Text("Всего попыток: ")
            Text("Правильных ответов: ")
        }
        .background(appSettings.palette.btnPrimaryColor)
        .font(.headline)
        .foregroundStyle(appSettings.palette.bgTextColor)
    }
    
    private var snapshotsView: some View {
        TabView(selection: $index) {
            ForEach(snapshotsVM.model.snapshots) { snapshot in
                VStack(spacing: 32) {
//                    Spacer()
                    DartsTargetView(.init(.shared), appSettings: .shared)
                        .overlay { DartsHitsView(snapshot.darts, appSettings: .shared) }
                    
//                    Spacer()
                    answersView(snapshot)
//                    Spacer()
                    
//                    VStack(spacing: 4) {
//                        Text("Счет: ")
//                        Text("Выбран ответ: ")
//                        Text("Затрачено времени: ")
//                        Text("Набрано очков: ")
//                    }
//                    .font(.headline)
//                    .foregroundStyle(appSettings.pallete.bgTextColor)
//                    HStack {
//                        ForEach(snapshot.darts) { dart in
//                            Text(dart.sector.description)
//                        }
//                    }
//                    Spacer()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//        .tabViewStyle()
    }
    
    private func answersView(_ snapshot: DartsGameSnapshot) -> some View {
        HStack(spacing: 10) {
            ForEach(snapshot.answers, id: \.self) { answer in
                let answerColor = getAnswerColor(answer, 
                                                 actual: snapshot.actual,
                                                 expected: snapshot.expected)
                DartsGameAnswerView(answer, color: answerColor)
            }
        }
    }
    
    private var snapshotsIndexView: some View {
        HStack(spacing: 4) {
            ForEach(0..<snapshotsVM.model.snapshots.count, id: \.self) { index in
                Circle()
                    .fill(getTabIndexColor(index))
                    .frame(width: 12)
                    .scaleEffect(index == self.index ? 1 : 0.75)
            }
        }
//        .padding()
    }
    
    private func getAnswerColor(_ answer: Int, actual: Int, expected: Int) -> Color {
        if answer == expected {
            appSettings.palette.optionsColor1
        } else if answer == actual {
            appSettings.palette.optionsColor2
        } else {
            appSettings.palette.btnSecondaryColor
        }
    }
    
    private func getTabIndexColor(_ index: Int) -> Color {
        self.index == index ? appSettings.palette.btnPrimaryColor : appSettings.palette.btnPrimaryColor.opacity(0.5)
    }
}

#Preview {
//    TabView {
//        NavigationStack {
            GameAnswersView(MockData.getDartsGameStats().items[0],
                            stats: MockData.getDartsGameSnapshotsList())
            .navigationBarTitleDisplayMode(.inline)
//        }
//        .toolbarBackground(.visible, for: .tabBar)
//        .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
//    }
}
