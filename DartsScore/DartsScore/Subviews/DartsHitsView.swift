//
//  DartsHitsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct DartsHitsView: View {
    private let darts: [Dart]
    @EnvironmentObject var appSettingsVM: AppSettingsViewModel
    
    init(_ darts: [Dart]) {
        self.darts = darts
    }
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint.getCenter(from: geometry)
            
            ForEach(darts) { dart in
                Image(systemName: appSettingsVM.dartImageName)
                    .resizable()
                    .frame(width: appSettingsVM.dartSize,
                           height: appSettingsVM.dartSize)
                    .bold()
                    .position(dart.globalPosition(center: center))
                    .foregroundStyle(appSettingsVM.dartColor)
            }
        }
    }
}

private struct TestDartsHitsView: View {
    @StateObject var appSettingsVM = AppSettingsViewModel()
    
    var body: some View {
        VStack {
            Text("Dart Size: \(appSettingsVM.dartSize)")
            DartsHitsView(MockData.getDartsGameSnapshotsList().snapshots[0].darts)
                .environmentObject(appSettingsVM)
        }
        .onAppear {
            appSettingsVM.dartSize = 16
        }
    }
}

struct DartsHitsView_Previews: PreviewProvider {
    static var previews: some View {
        TestDartsHitsView()
    }
}
