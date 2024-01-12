//
//  ViewExt.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 28.11.2023.
//

import SwiftUI

extension View {
    func blurredSheet<Content: View>(
        _ style: AnyShapeStyle,
        show: Binding<Bool>,
        onDissmiss: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        if #available(iOS 16.4, *) {
            return self.sheet(isPresented: show, onDismiss: onDissmiss) {
                content()
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(50)
            }
        } else {
            return self.sheet(isPresented: show, onDismiss: onDissmiss) {
                content()
                    .background(ClearedBackground())
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Rectangle()
                            .fill(style)
                            .ignoresSafeArea()
                    }
            }
        }
    }
    
    func glowingOutline(color: Color = Palette.btnPrimary) -> some View {
        modifier(GlowingOutline(color: color))
    }
}

private struct ClearedBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}

struct GlowingOutline: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(color, lineWidth: 2)
                    .shadow(color: color, radius: 5)
            }
    }
}
