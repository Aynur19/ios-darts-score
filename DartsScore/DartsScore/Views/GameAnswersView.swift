//
//  GameAnswersView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 23.11.2023.
//

import SwiftUI

private struct GameAnswersViewConstants {
    static let vSpacing: CGFloat = 32
    static let hSpacing: CGFloat = 12
    static let indexHSpacing: CGFloat = 4
    static let indexSize: CGFloat = 12
}

struct GameAnswersView: View {
    private typealias Constants = GameAnswersViewConstants
    
    @Environment(\.dartsTargetSize) var dartsTargetSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.dartsTargetWidth
    )

    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.dartsTargetWidth),
        missesIsEnabled: AppInterfaceDefaultSettings.dartMissesIsEnabled,
        dartSize: AppInterfaceDefaultSettings.dartSize,
        dartImageName: AppInterfaceDefaultSettings.dartImageName
    )
    
    @State private var index = 0
    @State private var detailsIsShowed = false
    
    private let game: DartsGame
    private let snapshots: DartsGameSnapshotsList
    
    init(game: DartsGame) {
        self.game = game
        self.snapshots = Self.getSnapshots(game)
    }
    
    private static func getSnapshots(_ game: DartsGame) -> DartsGameSnapshotsList {
        if isPreview { return MockData.getDartsGameSnapshotsList() }

        return JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
    }
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack {
                titleView
                Spacer()
                snapshotsView
                Spacer()
                snapshotsIndexView
                Spacer()
                detailsButtonView
                Spacer()
            }
            .padding(.top)
            .blurredSheet(
                .init(.ultraThinMaterial),
                show: $detailsIsShowed,
                onDissmiss: {},
                content: { gameAnswersSheet }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { 
            StaticUI.toolbarTitle { Text("viewTitle_AnswersHistory") }
        }
        .onAppear { reset() }
    }
    
    private var titleView: some View {
        Text("label_Answer \(answerIdx)")
            .font(.headline)
            .bold()
    }
    
    private var answerIdx: Int { index + 1 }
    
    private var snapshotsView: some View {
        TabView(selection: $index) {
            ForEach(snapshots.snapshots) { snapshot in
                VStack {
                    Spacer()
                    DartsTargetView()
                        .environmentObject(dartsTargetVM)
                        .overlay {
                            DartsHitsView()
                                .environmentObject(dartsHitsVM)
                                .onAppear {
                                    dartsHitsVM.replaceDarts(newDarts: snapshot.darts)
                                }
                        }
                    
                    Spacer()
                    answersView(snapshot)
                        .padding(.vertical)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    private func answersView(_ snapshot: DartsGameSnapshot) -> some View {
        HStack(spacing: Constants.hSpacing) {
            ForEach(snapshot.answers, id: \.self) { answer in
                let answerColor = getAnswerColor(
                    answer,
                    actual: snapshot.actual,
                    expected: snapshot.expected
                )
                
                GameAnswerView(score: answer, color: answerColor)
            }
        }
    }
    
    private var snapshotsIndexView: some View {
        HStack(spacing: Constants.indexHSpacing) {
            ForEach(snapshots.snapshots.indices, id: \.self) { index in
                Circle()
                    .fill(getTabIndexColor(index))
                    .frame(width: Constants.indexSize)
                    .scaleEffect(index == self.index ? 1 : 0.75)
            }
        }
    }
    
    private var detailsButtonView: some View {
        Button(
            action: { detailsIsShowed = true },
            label: { Text("label_Details") }
        )
        .padding(.bottom, 32)
    }
    
    private var gameAnswersSheet: some View {
        GameStatisticsSheet(
            game: game,
            snapshots: snapshots
        )
        .presentationDetents([.medium, .fraction(0.95)])
    }
}

extension GameAnswersView {
    private var interfaceSettings: AppInterfaceSettings { appSettingsVM.interfaceSettings }
    
    private var soundSettings: AppSoundSettings { appSettingsVM.soundSettings }
    
    private var dartsTarget: DartsTarget { dartsTargetVM.model }
    
    private func reset() {
        dartsTargetVM.reset(frameWidth: dartsTargetSize)
        dartsHitsVM.reset(
            dartsTarget: dartsTarget,
            missesIsEnabled: interfaceSettings.dartMissesIsEnabled,
            dartSize: interfaceSettings.dartSize,
            dartImageName: interfaceSettings.dartImageName
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


// MARK: Preview
private struct TestGameAnswersView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    GameAnswersView( game: MockData.getDartsGameStats().items[0])
                        .navigationBarTitleDisplayMode(.inline)
                        .environment(\.dartsTargetSize,
                                      DartsConstants.getDartsTargetWidth(windowsSize: geometry.size))
                        .environmentObject(appSettingsVM)
                }
                
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color(UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8)), for: .tabBar)
        }
    }
}

#Preview { TestGameAnswersView() }
