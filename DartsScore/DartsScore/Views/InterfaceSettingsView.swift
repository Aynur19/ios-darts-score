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
    
    @State private var dartImageName: DartImageName = Defaults.dartImageName
    @State private var dartImageNameIdx: Int = Defaults.dartImageNameIdx
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    dartImageSettings
                    dartSizeSettings
                    
                    Spacer()
                    Text("label_Preview")
                    dartsPreview
                    Spacer()
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
        .onAppear {
            setDartImageNameIdx()
            reset()
        }
    }
    
    private var dartImageSettings: some View {
        VStack {
            HStack {
                Text("label_DartImage") // Изображение попадания
                Spacer()
                dartImageName.image(size: 20)
            }
            
            StaticUI.hWheelPickerCursor

            HWheelPickerView(
                data: Defaults.dartImageNamesData,
                valueIdx: Binding(
                    get: { self.dartImageNameIdx },
                    set: { newValue in
                        onChangedDartImageNameIdx(idx: newValue)
                    }
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
    
    private var dartSizeSettings: some View {
        HStepperView(
            value: Binding(
                get: { self.dartSize },
                set: { newValue in
                    self.dartSize = newValue
                    dartsHitsVM.updateDartView(
                        imageName: dartImageName,
                        size: dartSize
                    )
                }
            ),
            range: 20...40,
            step: 1,
            buttonsContainerBackground: Palette.btnPrimary.opacity(0.25),
            labelView: { value in
                Text("label_DartSize \(value)") // Размер попадания:
            },
            dividerView: {
                Rectangle()
                    .fill(Palette.btnPrimary)
                    .frame(width: 1.5, height: 20)
            }
        )
        .padding(20)
        .glowingOutline()
    }
    
    private var dartsPreview: some View {
        DartsTargetView(dartsTargetPalette: .classic)
            .environmentObject(dartsTargetVM)
            .overlay {
                DartsHitsView()
                    .environmentObject(dartsHitsVM)
            }
    }
}

extension InterfaceSettingsView {
    private func setDartImageNameIdx() {
        guard let idx = Defaults.dartImageNamesData.firstIndex(of: dartImageName) else {
            return onChangedDartImageNameIdx(idx: Defaults.dartImageNameIdx)
        }
        
        onChangedDartImageNameIdx(idx: idx)
    }
    
    private func onChangedDartImageNameIdx(idx: Int) {
        dartImageNameIdx = idx
        dartImageName = Defaults.dartImageNamesData[idx]
        dartImageNameStr = dartImageName.rawValue
        
        dartsHitsVM.updateDartView(
            imageName: dartImageName,
            size: dartSize
        )
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
        
        dartsHitsVM.updateDarts()
    }
}

private struct TestInterfaceSettingsView: View {
    var body: some View {
        GeometryReader { geometry in
            TabView {
                NavigationStack {
                    InterfaceSettingsView()
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
