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
    
    @Environment(\.mainWindowSize) var windowSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.defaultDartsTargetWidth
    )

    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.defaultDartsTargetWidth),
        missesIsEnabled: AppInterfaceDefaultSettings.dartMissesIsEnabled,
        dartSize: AppInterfaceDefaultSettings.dartSize,
        dartImageName: AppInterfaceDefaultSettings.dartImageName
    )
    
    @ObservedObject var snapshotsVM: DartsGameAnswersViewModel
    
    @State private var index = 0
    @State private var detailsIsShowed = false
    
    init(game: DartsGame) {
        snapshotsVM = .init(game)
    }
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: Constants.vSpacing) {
                titleView
                snapshotsView
                snapshotsIndexView
                Spacer()
                detailsButtonView
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
            ForEach(snapshots) { snapshot in
                VStack {
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
                
                DartsGameAnswerView(score: answer, color: answerColor)
            }
        }
    }
    
    private var snapshotsIndexView: some View {
        HStack(spacing: Constants.indexHSpacing) {
            ForEach(snapshots.indices, id: \.self) { index in
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
    }
    
    private var gameAnswersSheet: some View {
        GameStatisticsSheet(
            game: snapshotsVM.game,
            snapshots: snapshotsVM.model
        )
        .presentationDetents([.medium, .fraction(0.95)])
    }
}

extension GameAnswersView {
    private var interfaceSettings: AppInterfaceSettings { appSettingsVM.interfaceSettings }
    
    private var soundSettings: AppSoundSettings { appSettingsVM.soundSettings }
    
    private var snapshots: [DartsGameSnapshot] { snapshotsVM.model.snapshots }
    
    private var dartsTarget: DartsTarget { dartsTargetVM.model }
    
    private func reset() {
        let frameWidth = DartsConstants.getDartsTargetWidth(windowsSize: windowSize)
        
        dartsTargetVM.reset(frameWidth: frameWidth)
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

private struct TestGameAnswersView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    GameAnswersView( game: MockData.getDartsGameStats().items[0])
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
