//
//  BluredPopup.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 25.12.2023.
//

import SwiftUI

struct BluredPopup<ContentType>: View
where ContentType: View {
    
    @ViewBuilder private var contentView: ContentType
    
    private let cornerRadius: CGFloat
    private let paddings: (l: CGFloat, r: CGFloat, t: CGFloat, b: CGFloat)
    private let material: Material
    
    init(
        @ViewBuilder contentView: () -> ContentType,
        cornerRadius: CGFloat = 25,
        paddings: (l: CGFloat, r: CGFloat, t: CGFloat, b: CGFloat) = (l: 32, r: 32, t: 128, b: 128),
        material: Material = .ultraThinMaterial
    ) {
        self.contentView = contentView()
        self.cornerRadius = cornerRadius
        self.paddings = paddings
        self.material = material
    }
    
    var body: some View {
        ZStack {
            Color.clear.background(material)
            
            contentView
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .padding(.leading, paddings.l)
        .padding(.trailing, paddings.r)
        .padding(.top, paddings.t)
        .padding(.bottom, paddings.b)
    }
}

private let labelHello = "Hello, World!"

#Preview {
    BluredPopup(
        contentView: { Text(labelHello) },
        cornerRadius: 30,
        paddings: (l: 24, r: 24, t: 64, b: 64),
        material: .thin
    )
}
