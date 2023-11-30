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
//                    .presentation
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
}

fileprivate struct ClearedBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            uiView.backgroundColor = .clear
            uiView.superview?.backgroundColor = .clear
            uiView.superview?.superview?.backgroundColor = .clear
            uiView.superview?.superview?.superview?.backgroundColor = .clear
        }
    }
}
