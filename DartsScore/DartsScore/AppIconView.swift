//
//  AppIconView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 30.11.2023.
//

import SwiftUI

private let appIconSize: CGFloat = 1024

struct AppIconView: View {
    var body: some View {
        ZStack {
            AppSettings.shared.palette.background
                .ignoresSafeArea()
            
            DartsTargetView(.init())
                .overlay {
                    DartsHitsView(MockData.getDartsGameSnapshotsList().snapshots[0].darts,
                                  appSettings: .shared)
                }
        }
    }
}

#Preview {
    AppIconView()
        .previewLayout(.fixed(width: appIconSize, 
                              height: appIconSize))
}
