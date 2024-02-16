//
//  StaticUI.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 19.12.2023.
//

import SwiftUI

struct StaticUI {
    /// The background of the application view.
    static var background: some View {
        Palette.background.ignoresSafeArea()
    }
    
    /// A function that applies the same style to the view title.
    /// - Parameters:
    ///   - title: a parameterless function that returns the view title.
    /// - Returns: returns a styled view title.
    static func toolbarTitle(@ViewBuilder title: () -> Text) -> ToolbarItem<Void, some View> {
        ToolbarItem(placement: .principal) {
            title()
                .font(.title)
                .foregroundStyle(Palette.bgText)
        }
    }
    
    
    // MARK: Horizontal Wheel Picker
    /// The cursor is on the selected element of the horizontal wheel picker.
    static var hWheelPickerCursor: some View {
        Image(systemName: "arrowtriangle.down.fill")
            .resizable()
            .frame(width: 8, height: 8)
            .foregroundStyle(Palette.btnPrimary)
    }
    
    /// Default view background for horizontal wheel picker.
    static var hWheelPickerBackground: some View {
        LinearGradient(
            colors: [.clear, Palette.btnPrimary.opacity(0.25), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Default presentation mask for horizontal wheel picker.
    static var hWheelPickerMask: some View {
        LinearGradient(
            colors: [.clear, Palette.bgText, .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    /// Default divider view of a horizontal wheel picker.
    static var hWheelPickerDivider: some View {
        Rectangle()
            .fill(Palette.btnPrimary)
            .frame(width: 1.5, height: 20)
    }
    
    /// Default item  view height and width of a horizontal wheel picker.
    static var hWheelPickerContentSize: CGSize { .init(width: 64, height: 32) }
    
    /// Minimum  view height of a horizontal wheel picker.
    static var hWheelPickerViewMinHeight: CGFloat { 32 }
    
    
    // MARK: Horizontal Stepper
    /// Horizontal stepper background color.
    static var hStepperViewBackground: Color {
        Palette.btnPrimary.opacity(0.25)
    }
    
    
    // MARK: Toggle
    /// Function to get view for toggle button depending on boolean value.
    static func toggleImageButtonChange(isOn: Bool) -> some View {
        Circle()
            .fill(Palette.btnPrimary)
            .overlay {
                Image(systemName: isOn ? "checkmark" : "xmark")
                    .foregroundStyle(Palette.btnPrimaryText)
            }
            .padding(2)
    }
    
    /// Function to get color for toggle depending on boolean value.
    static func toggleImageBackgroundChange(isOn: Bool) -> Color {
        isOn ? Palette.btnPrimary.opacity(0.5) : Color(.systemGray4)
    }
}
