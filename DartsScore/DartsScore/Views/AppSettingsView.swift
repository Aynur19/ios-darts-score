//
//  AppSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct AppSettingsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    private let attemptsCountData = AppSettings.attemptsCountData
    @State private var attemptsCount: Int = .zero
    
    private let timesForAnswerData = AppSettings.timesForAnswerData
    @State private var timeForAnswerIdx: Int = .zero
    
    init() {
        self.attemptsCount = appSettingsVM.attemptsCount
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        attemptsSettings
                        timeForAnswerView
                    }
                    .font(.headline)
                    .padding(32)
                }
                .onAppear {
                    self.timeForAnswerIdx = appSettingsVM.timeForAnswer
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("viewTitle_AppSettings")
                        .font(.title2)
                        .foregroundStyle(Palette.bgText)
                }
            }
        }
    }
    
    private var attemptsSettings: some View {
        VStack {
            Text("Количество попыток за игру")
                .foregroundStyle(Palette.btnPrimary)
            CustomSegmentedPickerView(attemptsCountData, $attemptsCount) {
                "\($0)"
            }
        }
    }
    
    private var timeForAnswerView: some View {
        VStack {
            HStack {
                Text("Время на ответ \t \(timesForAnswerData[timeForAnswerIdx]) сек.")
            }
            .foregroundStyle(Palette.btnPrimary)
            
            HWheelPickerView(timesForAnswerData, $timeForAnswerIdx) { item in
                Text("\(item)")
            } dividerView: {
                Palette.bgText.opacity(0.75)
            } backgroundView: {
                LinearGradient(colors: [.clear, Palette.btnPrimary.opacity(0.5), .clear],
                               startPoint: .leading,
                               endPoint: .trailing)
            } maskView: {
                LinearGradient(colors: [.clear, Palette.bgText.opacity(0.75), .clear],
                               startPoint: .leading,
                               endPoint: .trailing)
            }
        }
    }
}

#Preview {
    TabView {
        AppSettingsView()
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Palette.tabBar, for: .tabBar)
    }
}
