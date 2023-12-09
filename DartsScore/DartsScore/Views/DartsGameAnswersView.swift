//
//  DartsGameAnswersView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

struct GameAnswersView: View {
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
//    @EnvironmentObject var dartSettingsVM: DartSettingsViewModel
    
//    @StateObject var appSettings = AppSettingsVM.shared
    @ObservedObject var snapshotsVM: DartsGameAnswersViewModel
    @State private var index = 0
    @State private var detailsIsShowed = false
    
    init(_ game: DartsGame, stats: DartsGameSnapshotsList) {
        print("GameAnswersView.\(#function)")
        snapshotsVM = .init(game)
    }
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack {
                Text("label_Answer \(index + 1)")// "Ответ "
                    .font(.headline)
                    .bold()
                
                snapshotsView
                snapshotsIndexView
                Spacer(minLength: 64)
                
                Button {
                    detailsIsShowed = true
                } label: {
                    Text("label_Details")// "Подробно"
                }
                
                Spacer(minLength: 32)
            }
            .blurredSheet(.init(.ultraThinMaterial), show: $detailsIsShowed) {
                
            } content: {
                DartsGameStatisticsSheet(snapshotsVM.game, snapshotsVM.model)
                    .presentationDetents([.medium, .fraction(0.95)])
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("viewTitle_AnswersHistory")
                    .font(.title2)
                    .foregroundStyle(Palette.bgText)
            }
        }
    }
    
    private var snapshotsView: some View {
        TabView(selection: $index) {
            ForEach(snapshotsVM.model.snapshots) { snapshot in
                VStack(spacing: 32) {
                    DartsTargetView(.init(AppConstants.dartsFrameWidth))
                        .overlay {
                            DartsHitsView(snapshot.darts)
                                .environmentObject(appSettingsVM)
                        }
                    
                    answersView(snapshot)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
    }
    
    private func getAnswerColor(_ answer: Int, actual: Int, expected: Int) -> Color {
        if answer == expected {
            Palette.options1
        } else if answer == actual {
            Palette.options2
        } else {
            Palette.btnSecondary
        }
    }
    
    private func getTabIndexColor(_ index: Int) -> Color {
        self.index == index ? Palette.btnPrimary : Palette.btnPrimary.opacity(0.5)
    }
}

#Preview {
    TabView {
        NavigationStack {
            GameAnswersView(MockData.getDartsGameStats().items[0],
                            stats: MockData.getDartsGameSnapshotsList())
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
    }
}
