//
//  AppInterfaceSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import SwiftUI

private struct AppInterfaceSettingsViewConstants {
    static let vSpacing: CGFloat = 16
    static let dartImageSize: CGFloat = 20
    
    static let dartSizeRange: ClosedRange<Int> = 20...40
}

struct AppInterfaceSettingsView: View {
    private typealias Defaults = AppInterfaceDefaultSettings
    private typealias Keys = AppInterfaceSettingsKeys
    private typealias Constants = AppInterfaceSettingsViewConstants
    
    @Environment(\.dartsTargetSize) var targetSize
    
    @StateObject var dartsTargetVM = DartsTargetViewModel(
        frameWidth: AppConstants.dartsTargetWidth
    )

    @StateObject var dartsHitsVM = DartsHitsViewModel(
        dartsTarget: .init(frameWidth: AppConstants.dartsTargetWidth),
        missesIsEnabled: Defaults.dartMissesIsEnabled,
        dartSize: Defaults.dartSize,
        dartImageName: Defaults.dartImageName
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
        let dartImageIdx = Defaults.getDartImageNameIdx(dartImageName: settings.dartImageName)
        
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
                VStack(spacing: Constants.vSpacing) {
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
            StaticUI.toolbarTitle { Text("viewTitle_InterfaceSettings") }
        }
        .onAppear { onAppear() }
    }
    
    private func onAppear() {
        dartsTargetVM.reset(frameWidth: targetSize)
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
    
    private func updateDartView() {
        dartsHitsVM.updateDartView(
            imageName: dartImageName,
            size: dartSize
        )
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
                dartImageName.image(size: Constants.dartImageSize)
            }
            
            StaticUI.hWheelPickerCursor

            HWheelPickerView(
                data: Defaults.dartImageNamesData,
                valueIdx: Binding(
                    get: { self.dartImageNameIdx },
                    set: { newValue in onChangedDartImageNameIdx(idx: newValue) }
                ),
                contentSize: StaticUI.HWheelPickerContentSize,
                contentView: { item in
                    item.image(size: Constants.dartImageSize)
                },
                dividerView: { Palette.btnPrimary },
                backgroundView: { StaticUI.hWheelPickerBackground },
                maskView: { StaticUI.hWheelPickerMask }
            )
            .frame(minHeight: StaticUI.HWheelPickerViewMinHeight)
        }
        .padding()
        .glowingOutline()
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
            range: Constants.dartSizeRange,
            step: 1,
            buttonsContainerBackground: StaticUI.hStepperViewBackground,
            labelView: { value in
                Text("label_DartSize \(value)")
            },
            dividerView: { StaticUI.hWheelPickerDivider }
        )
        .padding()
        .glowingOutline()
    }
    
    private func onChangedDartSize(size: Int) {
        dartSize = size
        updateDartView()
    }
    
    // MARK: Dart Misses Switcher
    private var dartsWithMissSettings: some View {
        Toggle(
            isOn: Binding(
                get: { self.dartMissesIsEnabled },
                set: { newValue in onChangedDartMissesIsEnabled(isEnabled: newValue) }
            ),
            label: { Text("label_MissesEnable") }
        )
        .toggleStyle(
            ImageToggleStyle(
                buttonChange: { isOn in StaticUI.toggleImageButtonChange(isOn: isOn) },
                backgroundChange: { isOn in StaticUI.toggleImageBackgroundChange(isOn: isOn) }
            )
        )
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
            .overlay {
                DartsHitsView().environmentObject(dartsHitsVM)
            }
    }
}

private struct TestInterfaceSettingsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    AppInterfaceSettingsView(settings: appSettingsVM.interfaceSettings)
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
