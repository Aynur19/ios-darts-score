//
//  ViewExt.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 28.11.2023.
//

import SwiftUI

extension View {
    func viewTitle(_ title: String, appSettings: AppSettings = .shared) -> some View {
        Text(title)
            .font(.title)
            .foregroundStyle(appSettings.pallet.bgTextColor)
    }
    
    func label(_ text: String, appSettings: AppSettings = .shared) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(appSettings.pallet.bgTextColor)
    }
}
