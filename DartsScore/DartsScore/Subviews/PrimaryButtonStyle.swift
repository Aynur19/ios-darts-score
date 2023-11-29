//
//  PrimaryButtonStyle.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 28.11.2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(AppSettings.shared.pallet.btnPrimaryColor)
            .foregroundStyle(AppSettings.shared.pallet.btnPrimaryTextColor)
            .bold()
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

#Preview {
    Button { } label: { Text("START") }
        .buttonStyle(PrimaryButtonStyle())
}