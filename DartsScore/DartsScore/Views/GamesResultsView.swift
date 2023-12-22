//
//  GamesResultsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

private struct DartsGameResultsViewConstants {
    static let chevronName = "chevron.right"
    static let hPadding: CGFloat = 32
    static let vPadding: CGFloat = 10
    static let rowCornerRadius: CGFloat = 20
}

struct GamesResultsView: View {
    private typealias Constants = DartsGameResultsViewConstants
    
    @StateObject var statsVM = GamesResultsViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                VStack {
                    headers
                    resultsList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                StaticUI.toolbarTitle { Text("viewTitle_Statistics") }
            }
            .navigationDestination(for: String.self) { gameIdx in
                if let game = statsVM.getGame(gameIdx) {
                    GameAnswersView(game: game)
                }
            }
            .onAppear { onAppear() }
        }
    }
    
    private func onAppear() {
        statsVM.refresh()
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
        .foregroundStyle(Palette.bgText)
        .padding(.trailing, Constants.hPadding)
        .padding(.horizontal, Constants.hPadding)
    }
    
    private var resultsList: some View {
        ScrollView {
            ForEach(statsVM.model.items) { game in
                Button(
                    action: { path.append(game.id) },
                    label: { row(game) }
                )
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
            Text(attemptsStr(game.attempts, success: game.correct))
                .frame(maxWidth: .infinity)
            Text("\(TimerStringFormat.secMs.msStr(game.timeSpent)) suffix_Seconds")
                .frame(maxWidth: .infinity)
            Image(systemName: Constants.chevronName)
        }
        .foregroundStyle(Palette.btnPrimaryText)
        .padding(.vertical, Constants.vPadding)
        .padding(.horizontal)
        .background(Palette.btnPrimary)
        .clipShape(RoundedRectangle(cornerRadius: Constants.rowCornerRadius))
    }
    
    private func attemptsStr(_ allAttempts: Int, success: Int) -> String {
        "\(success)/\(allAttempts)"
    }
}

private struct TestGamesResultsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                GamesResultsView()
                    .environment(\.mainWindowSize, geometry.size)
                    .environmentObject(appSettingsVM)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

#Preview {
    TestGamesResultsView()
}
