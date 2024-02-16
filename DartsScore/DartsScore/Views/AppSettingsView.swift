//
//  AppSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI
import SwiftUIComponents4iOS

private enum SettingsSubviews: String {
    case interface
    case sound
}

private struct AppSettingsViewConstants {
    static let vSpacing: CGFloat = 16
}

struct AppSettingsView: View {
    private typealias Defaults = AppDefaultSettings
    private typealias Keys = AppSettingsKeys
    private typealias Constants = AppSettingsViewConstants
    
    @State private var path = NavigationPath()
    
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @AppStorage(Keys.attempts.rawValue)
    var attempts = Defaults.attempts
    
    @AppStorage(Keys.timeForAnswer.rawValue)
    var timeForAnswer: Int = Defaults.timeForAnswer
    
    @State private var timeForAnswerIdx: Int = 0
    
    init(settings: AppSettings) {
        let timeForAnswerIdx = Defaults.getTimeAnswerIdx(value: settings.timeForAnswer)
        self.timeForAnswerIdx = timeForAnswerIdx
        self.timeForAnswer = Defaults.timesForAnswerData[timeForAnswerIdx]
        
        self.attempts = settings.attempts
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Constants.vSpacing) {
                        attemptsSettings
                        timeForAnswerSettings
                        interfaceSettingsButton
                        soundSettingsButton
                    }
                    .foregroundStyle(Palette.btnPrimary)
                    .font(.headline)
                    .padding()
                }
            }
            .onAppear { appSettingsVM.update() }
            .onDisappear { appSettingsVM.update() }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                StaticUI.toolbarTitle { Text("viewTitle_AppSettings") }
            }
            .navigationDestination(for: SettingsSubviews.self) { settingsSubview in
                getSettingsView(subviewName: settingsSubview)
            }
        }
    }
    
    @ViewBuilder
    private func getSettingsView(subviewName: SettingsSubviews) -> some View {
        switch subviewName {
            case .interface:
                AppInterfaceSettingsView(settings: appSettingsVM.interfaceSettings)
            case .sound:
                AppSoundSettingsView()
        }
    }
    
    
    // MARK: Attemts Settings
    private var attemptsSettings: some View {
        VStack {
            HStack {
                Text("label_AttemptsForGame")
                Spacer()
                Text("\(attempts)")
            }

            HStaticSegmentedPickerView(
                data: Defaults.attemptsCountData,
                value: $attempts,
                backgroundColor: UIColor(Palette.btnPrimary.opacity(0.2)),
                selectedSegmentTintColor: UIColor(Palette.btnPrimary),
                selectedForecroundColor: UIColor(Palette.btnPrimaryText),
                normalForegroundColor: UIColor(Palette.btnPrimary),
                contentView: { item in
                    Text("\(item)")
                }
            )
        }
        .padding()
        .glowingOutline()
    }
    
    
    // MARK: Time For Answer Settings
    private var timeForAnswerSettings: some View {
        VStack {
            HStack {
                Text("label_TimeForAnswer")
                Spacer()
                Text("\(timeForAnswer.msToSec) suffix_Seconds")
            }

            StaticUI.hWheelPickerCursor

            HWheelPickerView(
                data: Defaults.timesForAnswerData,
                valueIdx: Binding(
                    get: { self.timeForAnswerIdx },
                    set: { newValue in onChangedTimeForAnswerIdx(newValue) }
                ),
                contentSize: StaticUI.hWheelPickerContentSize,
                contentView: { item in
                    Text("\(item.msToSec)")
                },
                dividerView: { StaticUI.hWheelPickerDivider },
                backgroundView: { StaticUI.hWheelPickerBackground },
                maskView: { StaticUI.hWheelPickerMask }
            )
            .frame(minHeight: StaticUI.hWheelPickerViewMinHeight )
        }
        .padding()
        .glowingOutline()
    }
    
    private func onChangedTimeForAnswerIdx(_ newValue: Int) {
        timeForAnswerIdx = newValue
        timeForAnswer = Defaults.timesForAnswerData[newValue]
    }
    
    
    // MARK: Interface Settings
    private var interfaceSettingsButton: some View {
        Button(
            action: { interfaceSettingsButtonAction() },
            label: { interfaceSettingsButtonLabel }
        )
        .padding()
        .glowingOutline()
    }
    
    private func interfaceSettingsButtonAction() {
        path.append(SettingsSubviews.interface)
    }
    
    private var interfaceSettingsButtonLabel: some View {
        HStack {
            Text("label_InterfaceSettings")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    
    // MARK: Sound Settings
    private var soundSettingsButton: some View {
        Button(
            action: { soundSettingsButtonAction() },
            label: { soundSettingsButtonLabel }
        )
        .padding()
        .glowingOutline()
    }
    
    private func soundSettingsButtonAction() {
        path.append(SettingsSubviews.sound)
    }
    
    private var soundSettingsButtonLabel: some View {
        HStack {
            Text("label_SoundSettings")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}


// MARK: Preview
private struct TestAppSettingsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            TabView {
                AppSettingsView(settings: appSettingsVM.settings)
                    .environment(\.mainWindowSize, geometry.size)
                    .environmentObject(appSettingsVM)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

#Preview { TestAppSettingsView() }
