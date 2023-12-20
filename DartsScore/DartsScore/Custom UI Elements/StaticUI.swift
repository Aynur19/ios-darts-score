//
//  StaticUI.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import SwiftUI

struct StaticUI {
    static var hWheelPickerCursor: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundStyle(Palette.btnPrimary)
    }
    
    static var hWheelPickerBackground: some View {
        LinearGradient(
            colors: [.clear, Palette.btnPrimary.opacity(0.25), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static var hWheelPickerMask: some View {
        LinearGradient(
            colors: [.clear, Palette.bgText, .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static var hWheelPickerDivider: some View {
        Rectangle()
            .fill(Palette.btnPrimary)
            .frame(width: 1.5, height: 20)
    }
    
    static func toggleImageButtonChange(isOn: Bool) -> some View {
        Circle()
            .fill(Palette.btnPrimary)
            .overlay {
                Image(systemName: isOn ? "checkmark" : "xmark")
                    .foregroundStyle(Palette.btnPrimaryText)
            }
            .padding(2)
    }
    
    static func toggleImageBackgroundChange(isOn: Bool) -> Color {
        isOn ? Palette.btnPrimary.opacity(0.5) : Color(.systemGray4)
    }
}
