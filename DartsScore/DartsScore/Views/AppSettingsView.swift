//
//  AppSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @State private var isChanged = false
    
    private let attemptsCountData = AppSettings.attemptsCountData
    @State private var attemptsCount: Int = .zero
    
    private let timesForAnswerData = AppSettings.timesForAnswerData
    
    init(_ appSettingsVM: AppSettingsViewModel = AppSettingsViewModel()) {
        print("init: DartsGameResultsViewConstants")
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("viewTitle_AppSettings")
                        .font(.title2)
                        .foregroundStyle(Palette.bgText)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        appSettingsVM.saveSettings()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!appSettingsVM.isChanged)
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
                Text("Время на ответ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(timesForAnswerData[appSettingsVM.timeForAnswerIdx]) сек.")
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal)
            .foregroundStyle(Palette.btnPrimary)
            
            HWheelPickerView(timesForAnswerData, $appSettingsVM.timeForAnswerIdx) { item in
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
            .onReceive(appSettingsVM.$timeForAnswerIdx) { _ in
                appSettingsVM.checkChanges()
            }
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    @StateObject static var appSettingsVM = AppSettingsViewModel()
    
    static var previews: some View {
        TabView {
            AppSettingsView()
                .environmentObject(appSettingsVM)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Palette.tabBar, for: .tabBar)
        }
    }
}
