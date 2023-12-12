//
//  AppSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct AppSettingsView: View {
    @Environment(\.mainWindowSize) var windowsSize
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    private let attemptsCountData = AppSettings.attemptsCountData
    private let timesForAnswerData = AppSettings.timesForAnswerData
    
    private let snapshots = MockData.getDartsGameSnapshotsList()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
//                        Image("Minus")
////                            .renderingMode(.original)
//                            .resizable()
//                            .frame(width: 64, height: 64)
//                            .colorMultiply(.green)
////                            .background { Color.yellow }
                        
                        attemptsSettings
                        timeForAnswerSettings
                        dartsWithMissSettings
                        hitImageSettings
                        hitSizeSettings
                        
                        DartsTargetView(.init(AppConstants.dartsFrameWidth))
                            .overlay { DartsHitsView(darts) }
                    }
                    .foregroundStyle(Palette.btnPrimary)
                    .font(.headline)
                    .padding(32)
                }
            }
            .onAppear { }
            .onDisappear {
                appSettingsVM.resetSettings()
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
    
    private var glowingOutline: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .stroke(Palette.btnPrimary, lineWidth: 2)
            .shadow(color: Palette.btnPrimary, radius: 5)
    }
    
    private var hWhheelPickerBackground: some View {
        LinearGradient(
            colors: [.clear, Palette.btnPrimary.opacity(0.25), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var hWhheelPickerMask: some View {
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
    
    private var darts: [Dart] {
        appSettingsVM.dartsWithMiss ? snapshots.snapshots[0].darts : snapshots.snapshots[1].darts
    }
    
    private var attemptsSettings: some View {
        VStack {
            HStack {
                Text("Количество попыток за игру")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(appSettingsVM.attempts)")
                    .multilineTextAlignment(.trailing)
            }
            
            HStaticSegmentedPickerView(
                data: attemptsCountData,
                value: $appSettingsVM.attempts,
                backgroundColor: UIColor(Palette.btnPrimary.opacity(0.2)),
                selectedSegmentTintColor: UIColor(Palette.btnPrimary),
                selectedForecroundColor: UIColor(Palette.btnPrimaryText),
                normalForegroundColor: UIColor(Palette.btnPrimary)
            ) { item in
                Text("\(item)")
            }
            .id(appSettingsVM.id)
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var timeForAnswerSettings: some View {
        VStack {
            HStack {
                Text("Время на ответ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(timesForAnswerData[appSettingsVM.timeForAnswerIdx]) сек.")
                    .multilineTextAlignment(.trailing)
            }
            
            hWheelPickerCursor
            
            HWheelPickerView(
                data: timesForAnswerData,
                valueIdx: $appSettingsVM.timeForAnswerIdx,
                contentSize: .init(width: 64, height: 32)
            ) { item in
                Text("\(item)")
            } dividerView: {
                hWheelPickerDivider
            } backgroundView: {
                hWhheelPickerBackground
            } maskView: {
                hWhheelPickerMask
            }
            .frame(minHeight: 32)
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var dartsWithMissSettings: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $appSettingsVM.dartsWithMiss) {
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
                
                appSettingsVM.dartImageName
                    .image(size: 20)
            }
            
            hWheelPickerCursor
            
            HWheelPickerView(
                data: AppSettings.dartImageNamesData,
                valueIdx: $appSettingsVM.dartImageNameIdx,
                contentSize: .init(width: 64, height: 32)
            ) { item in
                item.image(size: 20)
            } dividerView: {
                hWheelPickerDivider
            } backgroundView: {
                hWhheelPickerBackground
            } maskView: {
                hWhheelPickerMask
            }
            .frame(minHeight: 32)
        }
        .padding()
        .overlay { glowingOutline }
    }
    
    private var hitSizeSettings: some View {
        HStepperView(
            value: $appSettingsVM.dartSize,
            range: 10...40,
            step: 1,
            labelView: { value in
                Text("Размер попадания: \(value)")
            }
        )
//        Stepper("Размер попадания: \(appSettingsVM.dartSize)",
//                value: $appSettingsVM.dartSize,
//                in: 10...30)
        .padding()
        .overlay { glowingOutline }

    }
}

private struct TestAppSettingsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        TabView {
            AppSettingsView()
                .environmentObject(appSettingsVM)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Palette.tabBar, for: .tabBar)
        }
        .onAppear {
            appSettingsVM.dartSize = 16
        }
    }
}

#Preview {
    TestAppSettingsView()
}
