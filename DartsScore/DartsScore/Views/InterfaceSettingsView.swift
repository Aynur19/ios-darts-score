//
//  InterfaceSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import SwiftUI

struct InterfaceSettingsView: View {
    private typealias Defaults = AppInterfaceDefaultSettings
    private typealias Keys = AppInterfaceSettingsKeys
    
    @Environment(\.mainWindowSize) var windowSize
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.defaultDartsTargetWidth
    )

    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.defaultDartsTargetWidth),
        missesIsEnabled: AppConstants.defaultDartsWithMiss,
        dartSize: AppConstants.defaultDartSize,
        dartImageName: AppConstants.defaultDartImageName
    )

    @AppStorage(Keys.dartImageName.rawValue)
    var dartImageNameStr: String = Defaults.dartImageName.rawValue
    
    @AppStorage(Keys.dartSize.rawValue)
    var dartSize: Int = Defaults.dartSize
    
    @AppStorage(Keys.dartMissesIsEnabled.rawValue)
    var dartMissesIsEnabled: Bool = Defaults.dartMissesIsEnabled
    
    @State private var dartImageNameIdx: Int
    @State private var dartImageName: DartImageName
    @State private var darts: [[Dart]] = []
    
    init(settings: AppInterfaceSettings) {
        let dartImageIdx = Self.getDartImageNameIdx(dartImageName: settings.dartImageName)
        
        dartImageNameIdx    = dartImageIdx
        dartImageName       = Defaults.dartImageNamesData[dartImageIdx]
        dartImageNameStr    = Defaults.dartImageNamesData[dartImageIdx].rawValue
        
        dartSize            = settings.dartSize
        dartMissesIsEnabled = settings.dartMissesIsEnabled
    }
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    dartImageSettings
                    dartSizeSettings
                    dartsWithMissSettings
                    dartsPreview
                }
                .padding()
                .foregroundStyle(Palette.btnPrimary)
                .font(.headline)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("viewTitle_InterfaceSettings")
                    .font(.title)
                    .foregroundStyle(Palette.bgText)
            }
        }
        .onAppear { onAppear() }
    }
    
    private func onAppear() {
        let frameWidth = DartsConstants.getDartsTargetWidth(windowsSize: windowSize)
        
        dartsTargetVM.reset(frameWidth: frameWidth)
        dartsHitsVM.reset(
            dartsTarget: dartsTargetVM.model,
            missesIsEnabled: dartMissesIsEnabled,
            dartSize: dartSize,
            dartImageName: dartImageName
        )
        
        updateDartView()
        setDarts()
        
        dartsHitsVM.replaceDarts(newDarts: dartMissesIsEnabled ? darts[0] : darts[1])
    }
    
    private func setDarts() {
        darts.append(MockData.getDartsGameSnapshotsList().snapshots[0].darts)
        darts.append(MockData.getDartsGameSnapshotsList().snapshots[1].darts)
    }
    
    // MARK: Dart Image
    private var dartImageSettings: some View {
        VStack {
            HStack {
                Text("label_DartImage")
                Spacer()
                dartImageName.image(size: 20)
            }
            
            StaticUI.hWheelPickerCursor

            HWheelPickerView(
                data: Defaults.dartImageNamesData,
                valueIdx: Binding(
                    get: { self.dartImageNameIdx },
                    set: { newValue in onChangedDartImageNameIdx(idx: newValue) }
                ),
                contentSize: .init(width: 64, height: 32),
                contentView: { item in
                    item.image(size: 20)
                },
                dividerView: { Palette.btnPrimary },
                backgroundView: { StaticUI.hWheelPickerBackground },
                maskView: { StaticUI.hWheelPickerMask }
            )
            .frame(minHeight: 32)
        }
        .padding(20)
        .glowingOutline()
    }
    
    private static func getDartImageNameIdx(dartImageName: DartImageName) -> Int {
        guard let idx = Defaults.dartImageNamesData.firstIndex(of: dartImageName) else {
            return Defaults.dartImageNameIdx
        }
        
        return idx
    }
    
    private func onChangedDartImageNameIdx(idx: Int) {
        dartImageNameIdx = idx
        dartImageName = Defaults.dartImageNamesData[idx]
        dartImageNameStr = dartImageName.rawValue
        
        updateDartView()
    }
    
    // MARK: Dart Size
    private var dartSizeSettings: some View {
        HStepperView(
            value: Binding(
                get: { self.dartSize },
                set: { newValue in onChangedDartSize(size: newValue) }
            ),
            range: 20...40,
            step: 1,
            buttonsContainerBackground: Palette.btnPrimary.opacity(0.25),
            labelView: { value in
                Text("label_DartSize \(value)") // Размер попадания:
            },
            dividerView: { StaticUI.hWheelPickerDivider }
        )
        .padding(20)
        .glowingOutline()
    }
    
    private func onChangedDartSize(size: Int) {
        dartSize = size
        updateDartView()
    }
    
    // MARK: Dart Misses Switcher
    private var dartsWithMissSettings: some View {
        VStack(spacing: 20) {
            Toggle(
                isOn: Binding(
                    get: { self.dartMissesIsEnabled },
                    set: { newValue in onChangedDartMissesIsEnabled(isEnabled: newValue) }
                ),
                label: { Text("Включить промахи") }
            )
            .toggleStyle(
                ImageToggleStyle(
                    buttonChange: { isOn in StaticUI.toggleImageButtonChange(isOn: isOn) },
                    backgroundChange: { isOn in StaticUI.toggleImageBackgroundChange(isOn: isOn) }
                )
            )
        }
        .padding()
        .glowingOutline()
    }
    
    private func onChangedDartMissesIsEnabled(isEnabled: Bool) {
        dartMissesIsEnabled = isEnabled
        dartsHitsVM.replaceDarts(newDarts: isEnabled ? darts[0] : darts[1])
    }

    // MARK: Preview
    private var dartsPreview: some View {
        DartsTargetView()
            .environmentObject(dartsTargetVM)
            .overlay { DartsHitsView().environmentObject(dartsHitsVM) }
    }
}

extension InterfaceSettingsView {
    private func updateDartView() {
        dartsHitsVM.updateDartView(
            imageName: dartImageName,
            size: dartSize
        )
    }
    
    private func setDartImageNameIdx() {
        print("InterfaceSettingsView.\(#function)")
        print("    dartImageName: \(dartImageName)")
        guard let idx = Defaults.dartImageNamesData.firstIndex(of: dartImageName) else {
            return onChangedDartImageNameIdx(idx: Defaults.dartImageNameIdx)
        }
        
        print("___idx: \(idx)")
        onChangedDartImageNameIdx(idx: idx)
    }

    private func reset() {
        let frameWidth = DartsConstants.getDartsTargetWidth(windowsSize: windowSize)
        
        dartsTargetVM.reset(frameWidth: frameWidth)
        dartsHitsVM.reset(
            dartsTarget: dartsTargetVM.model,
            missesIsEnabled: true,
            dartSize: dartSize,
            dartImageName: dartImageName
        )
        
//        dartsHitsVM.updateDarts()
//        updateDarts()
    }
}

private struct TestInterfaceSettingsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    InterfaceSettingsView(settings: appSettingsVM.interfaceSettings)
                        .environment(\.mainWindowSize, geometry.size)
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Palette.tabBar, for: .tabBar)
            }
        }
    }
}

#Preview {
    TestInterfaceSettingsView()
}
