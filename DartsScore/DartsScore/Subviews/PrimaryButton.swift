//
//  PrimaryButton.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 28.11.2023.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let color = Color(UIColor(red: 1, green: 0.61, blue: 0.2, alpha: 1))
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(Color.black)
                .bold()
        }
        .buttonStyle(PrimaryButtonStyle())
//        .frame(maxWidth: .infinity)
//        .padding(.vertical)
////        .cor
//        .background(Color(UIColor(red: 1, green: 0.61, blue: 0.2, alpha: 1)))
//        .clipShape(RoundedRectangle(cornerRadius: 25.0))
//        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
//        .padding()
    }
}

#Preview {
    PrimaryButton("START") { }
}
