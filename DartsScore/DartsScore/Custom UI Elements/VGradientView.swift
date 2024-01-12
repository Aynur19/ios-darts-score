//
//  ColoredListView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.01.2024.
//

import SwiftUI

enum GradientViews {
    case background
    case stroke
    case all
}

struct VGradientView<ContentType, ShapeType>: View
where ContentType: View,
      ShapeType: Shape {
    
    @ViewBuilder private let contentView: ContentType
    @ViewBuilder private let shapeView: ShapeType
    private let gradient: () -> [Color]
    private let parentSize: CGSize
    private let gradientView: GradientViews
    private let strokeWidth: CGFloat
    
    @State private var offset: CGFloat = 0
    
    init(
        @ViewBuilder contentView: () -> ContentType,
        @ViewBuilder shapeView: () -> ShapeType = { Capsule() },
        gradient: @escaping () -> [Color] = { [.green, .yellow, .red] },
        parentSize: CGSize,
        gradientView: GradientViews = .background,
        strokeWidth: CGFloat = 5
    ) {
        self.contentView    = contentView()
        self.shapeView      = shapeView()
        self.gradient       = gradient
        self.parentSize     = parentSize
        self.gradientView   = gradientView
        self.strokeWidth    = strokeWidth
    }
    
    var body: some View {
        content
            .background { gradientChangeBackground }
            .onPreferenceChange(GradientViewOffsetKey.self) {
                offset = $0
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if gradientView == .background {
            contentView
                .background { gradientBackground }
        } else if gradientView == .stroke {
            contentView
                .overlay { gradientStroke }
        } else {
            contentView
                .overlay { gradientStroke }
                .background { gradientBackground }
        }
    }
    
    private var gradientStroke: some View {
        GeometryReader {
            shapeView
                .stroke(
                    gradientStroke(
                        offset: offset,
                        height: $0.size.height
                    ),
                    lineWidth: strokeWidth
                )
        }
    }
    
    private var gradientBackground: some View {
        GeometryReader {
            gradientBackground(
                offset: offset,
                height: $0.size.height
            )
        }
    }
    
    private var gradientChangeBackground: some View {
        GeometryReader {
            Color.clear.preference(
                key: GradientViewOffsetKey.self,
                value: $0.frame(in: .global).minY
            )
        }
    }
    
    private func gradientBackground(offset: CGFloat, height: CGFloat) -> some View {
        let startY = offset / height
        let endY = 1 + (parentSize.height - offset - height) / height
        
        return LinearGradient(
            colors: gradient(),
            startPoint: .init(x: 0, y: -startY),
            endPoint: .init(x: 0, y: endY)
        )
        .frame(width: parentSize.width, height: parentSize.height)
    }
    
    private func gradientStroke(offset: CGFloat, height: CGFloat) -> some ShapeStyle {
        let startY = offset / height
        let endY = 1 + (parentSize.height - offset - height) / height
        
        return LinearGradient(
            colors: gradient(),
            startPoint: .init(x: 0, y: -startY),
            endPoint: .init(x: 0, y: endY)
        )
    }
}

private struct GradientViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

private struct TestVGradientView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    VGradientView(
                        contentView: { Text("Item 1").padding() },
                        parentSize: geometry.size
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VGradientView(
                        contentView: { Text("Item 2").padding() },
                        shapeView: {
                            RoundedRectangle(cornerRadius: 10)
                        },
                        parentSize: geometry.size,
                        gradientView: .stroke
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                    VGradientView(
                        contentView: { Text("Item 3").padding() },
                        parentSize: geometry.size
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    TestVGradientView()
}
