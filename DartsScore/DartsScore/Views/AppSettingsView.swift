//
//  AppSettingsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    private let attemptsCountData = AppSettings.attemptsCountData
    private let timesForAnswerData = AppSettings.timesForAnswerData
    
    private let snapshots = MockData.getDartsGameSnapshotsList()
    
    init() {
        print("\n****************************")
        print("AppSettingsView.\(#function)")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        attemptsSettings
                        timeForAnswerSettings
                        
                        dartsWithMissSettings
                        
                        hitImageSettings
                        
                        
                        DartsTargetView(.init())
                            .overlay {
                                DartsHitsView(snapshots.snapshots[1].darts)
                                    .environmentObject(appSettingsVM)
                            }
                    }
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
    
    private var attemptsSettings: some View {
        VStack {
            HStack {
                Text("Количество попыток за игру")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(appSettingsVM.attempts)")
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal)
            .foregroundStyle(Palette.btnPrimary)
            
            HSegmentedPickerView(
                attemptsCountData,
                $appSettingsVM.attempts,
                backgroundColor: UIColor(Palette.btnPrimary.opacity(0.25)),
                selectedSegmentTintColor: UIColor(Palette.btnPrimary),
                selectedForecroundColor: UIColor(Palette.btnPrimaryText),
                normalForegroundColor: UIColor(Palette.bgText.opacity(0.75))
            ) { item in
                Text("\(item)")
            }
        }
    }
    
    private var timeForAnswerSettings: some View {
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
                LinearGradient(colors: [.clear, Palette.bgText, .clear],
                               startPoint: .leading,
                               endPoint: .trailing)
            }
        }
    }
    
    private var dartsWithMissSettings: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $appSettingsVM.dartsWithMiss) {
                Text("Включить промахи")
                    .foregroundStyle(Palette.btnPrimary)
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
            .padding(.top, 20)
            .padding(.horizontal)
//        }
    }
    
    private var hitImageSettings: some View {
        VStack {
            HStack {
                Text("Изображение попадания")
                Spacer()
                Image(systemName: appSettingsVM.dartImageName)
            }
            .foregroundStyle(Palette.btnPrimary)
            
            HWheelPickerView(
                AppSettings.dartImageNamesData,
                $appSettingsVM.dartImageNameIdx,
                contentSize: .init(width: 64, height: 36)
            ) { item in
                Image(systemName: item)
            } dividerView: {
                Palette.bgText.opacity(0.75)
            } backgroundView: {
                LinearGradient(colors: [.clear, Palette.btnPrimary.opacity(0.5), .clear],
                               startPoint: .leading,
                               endPoint: .trailing)
            } maskView: {
                LinearGradient(colors: [.clear, Palette.bgText, .clear],
                               startPoint: .leading,
                               endPoint: .trailing)
            }
            .frame(minHeight: 36)
        }
        .padding(.horizontal)
    }
}

struct ImageToggleStyle<ButtonType>: ToggleStyle
where ButtonType: View{
    
    let buttonChange: (Bool) -> ButtonType
//    @ViewBuilder let disableContentView: DisableContentType
    let backgroundChange: (Bool) -> Color

    let frameSize: CGSize
    let cornerRadius: CGFloat
//    let activeImage: Image
//    let activeBgColor: Color
//    let activeBtnBgColor: Color
//    let activeBtnFgColor: Color
//    
//    let inactiveImage: Image
//    let inactiveBgColor: Color
//    let inactiveBtnBgColor: Color
//    let inactiveBtnFgColor: Color
    
//    init(
//        _ activeImage: Image = .init(systemName: "circle.fill"),
//        _ activeBgColor: Color = .green,
//        _ activeFgColor: Color = .white,
//        inactiveImage: Image = .init(systemName: "circle.fill"),
//        inactiveBgColor: Color = Color(.systemGray4),
//        inactiveFgColor: Color = .white
//    ) {
//        self.activeImage = activeImage
//        self.activeBgColor = activeBgColor
//        self.activeFgColor = activeFgColor
//        
//        self.inactiveImage = inactiveImage
//        self.inactiveBgColor = inactiveBgColor
//        self.inactiveFgColor = inactiveFgColor
//    }
    
    init(
        frameSize: CGSize = .init(width: 50, height: 32),
        cornerRadius: CGFloat = 30,
        _ buttonChange: @escaping (Bool) -> ButtonType,
//        @ViewBuilder enableContentView: () -> EnableContentType,
//        @ViewBuilder disableContentView: () -> DisableContentType,
        backgroundChange: @escaping (Bool) -> Color = { isOn in
            isOn ? .green : Color(.systemGray4)
        }
    ) {
        self.frameSize = frameSize
        self.cornerRadius = cornerRadius
        self.buttonChange = buttonChange
        self.backgroundChange = backgroundChange
    }
 
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
 
            Spacer()
 
            RoundedRectangle(cornerRadius: cornerRadius)
//                .fill(configuration.isOn ? activeBgColor : inactiveBgColor)
                .fill(backgroundChange(configuration.isOn))
                .overlay {
                    buttonChange(configuration.isOn)
//                        .frame(width: frameSize.height - 2,
//                               height: frameSize.height - 2)
                        .offset(x: configuration.isOn ? xOffset : -xOffset)
//                    toggleFront(configuration.isOn)
//                    Circle()
//                        .fill(Palette.btnPrimary)
//                        .frame(width: 28)
////                        .padding(.horizontal, 1)
//                        .overlay { toggleFront(configuration.isOn) }
//
 
                }
                .frame(width: frameSize.width, height: frameSize.height)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
    
    private var xOffset: CGFloat {
        (frameSize.width - frameSize.height).half
    }
                             
//    private func toggleFront(_ isOn: Bool) -> some View {
//        (isOn ? activeImage : inactiveImage)
////            .renderingMode(.original)
//
//            .font(.title2)
////            .frame(width: 50, height: 50)
//            .foregroundColor(isOn ? activeFgColor : inactiveFgColor)
////            .background(Palette.btnPrimary)
//            .clipShape(Circle())
//    }
//    
//    private func bgColor(_ isOn: Bool) -> Color {
//        isOn ? activeBgColor : inactiveBgColor
//    }
    
    
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
