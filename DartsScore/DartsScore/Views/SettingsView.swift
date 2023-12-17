//
//  SettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct SettingsView: View {
    private typealias Constants = AppConstants
    
    @Environment(\.mainWindowSize) var windowsSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    @ObservedObject var settingsVM: SettingsViewModel
    
    @State private var appearDatetimeId: String = ""
    
    init(appSettings: AppSettings) {
        print("AppSettingsView.\(#function)")
        settingsVM = .init(appSettings: appSettings)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        attemptsSettings
                        timeForAnswerSettings
                        dartsWithMissSettings
                        hitImageSettings
                        hitSizeSettings
                        
//                        DartsTargetView(
//                            .init(AppConstants.dartsFrameWidth),
//                            dartsTargetPalette: .classic
//                        )
//                        .overlay {
//                            DartsHitsView(
//                                settingsVM.darts,
//                                dartSize: CGFloat(settingsVM.dartSize),
//                                dartImageName: settingsVM.dartImageName
//                            )
//                        }
                    }
                    .foregroundStyle(Palette.btnPrimary)
                    .font(.headline)
                    .padding(32)
                }
            }
            .onAppear {
                appearDatetimeId = Date().description
            }
            .onDisappear { cancelSettings() }
//            .onDisappear {
//                appSettingsVM.resetSettings()
//            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("viewTitle_AppSettings")
                        .font(.title2)
                        .foregroundStyle(Palette.bgText)
                }
                
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        resetSettings()
                    } label: {
                        Text("Reset")
                    }
                    .disabled(settingsVM.isDefaults)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveSettings()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!settingsVM.isChanged)
                }
            }

        }
    }
    
    private var glowingOutline: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .stroke(Palette.btnPrimary, lineWidth: 2)
            .shadow(color: Palette.btnPrimary, radius: 5)
    }
    
    private var hWheelPickerBackground: some View {
        LinearGradient(
            colors: [.clear, Palette.btnPrimary.opacity(0.25), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var hWheelPickerMask: some View {
        LinearGradient(
            colors: [.clear, Palette.bgText, .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var hWheelPickerCursor: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundStyle(Palette.btnPrimary)
    }
    
    private var hWheelPickerDivider: some View {
        Palette.btnPrimary
    }
    
    private var attemptsSettings: some View {
        VStack {
            HStack {
                Text("Количество попыток за игру")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(settingsVM.attempts)")
                    .multilineTextAlignment(.trailing)
            }
            
            HStaticSegmentedPickerView(
                data: Constants.attemptsCountData,
                value: $settingsVM.attempts,
                backgroundColor: UIColor(Palette.btnPrimary.opacity(0.2)),
                selectedSegmentTintColor: UIColor(Palette.btnPrimary),
                selectedForecroundColor: UIColor(Palette.btnPrimaryText),
                normalForegroundColor: UIColor(Palette.btnPrimary)
            ) { item in
                Text("\(item)")
            }
            .id(appearDatetimeId)
//            .id(appSettingsVM.id)
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var timeForAnswerSettings: some View {
        VStack {
            HStack {
                Text("Время на ответ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(settingsVM.timeForAnswer) сек.")
                    .multilineTextAlignment(.trailing)
            }
            
            hWheelPickerCursor
            
            HWheelPickerView(
                data: Constants.timesForAnswerData,
                valueIdx: $settingsVM.timeForAnswerIdx,
                contentSize: .init(width: 64, height: 32)
            ) { item in
                Text("\(item)")
            } dividerView: {
                hWheelPickerDivider
            } backgroundView: {
                hWheelPickerBackground
            } maskView: {
                hWheelPickerMask
            }
            .frame(minHeight: 32)
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var dartsWithMissSettings: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $settingsVM.dartsWithMiss) {
                Text("Включить промахи")
            }
            .toggleStyle(
                ImageToggleStyle { isOn in
                    Circle()
                        .fill(Palette.btnPrimary)
                        .overlay {
                            Image(systemName: isOn ? "checkmark" : "xmark")
                                .foregroundStyle(Palette.btnPrimaryText)
                        }
                        .padding(2)
                } backgroundChange: { isOn in
                    isOn ? Palette.btnPrimary.opacity(0.5) : Color(.systemGray4)
                }
            )
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var hitImageSettings: some View {
        VStack {
            HStack {
                Text("Изображение попадания")
                Spacer()
                
                settingsVM.dartImageName.image(size: 20)
            }
            
            hWheelPickerCursor
            
            HWheelPickerView(
                data: Constants.dartImageNamesData,
                valueIdx: $settingsVM.dartImageNameIdx,
                contentSize: .init(width: 64, height: 32)
            ) { item in
                item.image(size: 20)
            } dividerView: {
                hWheelPickerDivider
            } backgroundView: {
                hWheelPickerBackground
            } maskView: {
                hWheelPickerMask
            }
            .frame(minHeight: 32)
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var hitSizeSettings: some View {
        HStepperView(
            value: $settingsVM.dartSize,
            range: 10...40,
            step: 1,
            buttonsContainerBackground: Palette.btnPrimary.opacity(0.25),
            labelView: { value in
                Text("Размер попадания: \(value)")
            },
            dividerView: {
                Rectangle()
                    .fill(Palette.btnPrimary)
                    .frame(width: 1.5, height: 20)
            }
        )
        .padding()
        .overlay { glowingOutline }
    }
    
    private func saveSettings() {
        appSettingsVM.save(settingsVM: settingsVM)
        settingsVM.checkChangesAndDefaults()
    }
    
    private func cancelSettings() {
        settingsVM.cancel()
    }
    
    private func resetSettings() {
        settingsVM.reset()
    }
    
//    private func toDefaultSettings() {
////        settingsVM.toDefault()
//    }
}

private struct TestAppSettingsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        TabView {
            SettingsView(appSettings: appSettingsVM.model)
                .environmentObject(appSettingsVM)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Palette.tabBar, for: .tabBar)
        }
    }
}

#Preview {
    TestAppSettingsView()
}
