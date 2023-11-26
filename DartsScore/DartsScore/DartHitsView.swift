//
//  DartsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.11.2023.
//

import SwiftUI

struct DartHitsView: View {
    private let darts: [Dart]
    private let appSettings: AppSettings
    
    init(
        _ darts: [Dart] = [],
        appSettings: AppSettings = .shared
    ) {
        self.darts = darts
        self.appSettings = appSettings
    }
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint.getCenter(from: geometry)
            
            ForEach(darts) { dart in
                Image(systemName: appSettings.dartImageName.rawValue)
                    .resizable()
                    .frame(width: appSettings.dartImageSize,
                           height: appSettings.dartImageSize)
                    .bold()
                    .position(dart.globalPosition(center: center))
                    .foregroundColor(appSettings.dartImageColor)
            }
        }
    }
}

#Preview {
    DartHitsView(
        MockData.getDartsGameStats()
            .items[0]
            .answers[0]
            .darts
    )
}
