//
//  DartsGameAnswersView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

struct GameAnswersView: View {
    @Environment(\.mainWindowSize) var windowSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.dartsFrameWidth
    )

    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.dartsFrameWidth),
        missesIsEnabled: AppConstants.defaultDartsWithMiss,
        dartSize: AppConstants.defaultDartSize,
        dartImageName: AppConstants.defaultDartImageName
    )
    
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
                Text("label_Answer \(index + 1)")
                    .font(.headline)
                    .bold()
                
                snapshotsView
                snapshotsIndexView
                Spacer(minLength: 64)
                
                Button {
                    detailsIsShowed = true
                } label: {
                    Text("label_Details")
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
        .onAppear { reset() }
    }
    
    private var snapshotsView: some View {
        TabView(selection: $index) {
            ForEach(snapshots) { snapshot in
                VStack(spacing: 32) {
                    DartsTargetView(dartsTargetPalette: .classic)
                        .environmentObject(dartsTargetVM)
                        .overlay {
                            DartsHitsView()
                                .environmentObject(dartsHitsVM)
                                .onAppear {
                                    dartsHitsVM.replaceDarts(newDarts: snapshot.darts)
                                }
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
                DartsGameAnswerView(score: answer, color: answerColor)
            }
        }
    }
    
    private var snapshotsIndexView: some View {
        HStack(spacing: 4) {
            ForEach(0..<snapshots.count, id: \.self) { index in
                Circle()
                    .fill(getTabIndexColor(index))
                    .frame(width: 12)
                    .scaleEffect(index == self.index ? 1 : 0.75)
            }
        }
    }
}

extension GameAnswersView {
    private var appSettings: AppSettings { appSettingsVM.model }
    
    private var snapshots: [DartsGameSnapshot] { snapshotsVM.model.snapshots }
    
    private var dartsTarget: DartsTarget { dartsTargetVM.model }
    
    private func reset() {
        let frameWidth = DartsConstants.getDartsTargetWidth(windowsSize: windowSize)
        
        dartsTargetVM.reset(frameWidth: frameWidth)
        dartsHitsVM.reset(
            dartsTarget: dartsTarget,
            missesIsEnabled: appSettings.dartsWithMiss,
            dartSize: appSettings.dartSize,
            dartImageName: appSettings.dartImageName
        )
    }
    
    private func getAnswerColor(_ answer: Int, actual: Int, expected: Int) -> Color {
        if answer == expected { return Palette.options1 }
        if answer == actual { return Palette.options2 }
        
        return Palette.btnSecondary
    }
    
    private func getTabIndexColor(_ index: Int) -> Color {
        self.index == index ? Palette.btnPrimary : Palette.btnPrimary.opacity(0.5)
    }
}

private struct TestGameAnswersView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    GameAnswersView(
                        MockData.getDartsGameStats().items[0],
                        stats: MockData.getDartsGameSnapshotsList()
                    )
                    .navigationBarTitleDisplayMode(.inline)
                    .environment(\.mainWindowSize, geometry.size)
                    .environmentObject(appSettingsVM)
                }
                
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
        }
    }
}

#Preview {
    TestGameAnswersView()
}
