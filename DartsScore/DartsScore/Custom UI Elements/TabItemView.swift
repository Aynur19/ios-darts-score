//
//  TabItemView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 26.12.2023.
//

import SwiftUI

struct TabItemView<ContentType, LabelType>: View
where ContentType: View,
      LabelType: View {

    @ViewBuilder private var contentView: ContentType
    @ViewBuilder private var labelView: LabelType
    
    init(
        @ViewBuilder contentView: () -> ContentType,
        @ViewBuilder labelView: () -> LabelType
    ) {
        self.contentView = contentView()
        self.labelView = labelView()
    }
    
    var body: some View {
        contentView
            .tabItem { labelView }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Palette.tabBar, for: .tabBar)
    }
}

private struct TestTabItemView: View {
    var body: some View {
        TabView {
            TabItemView(
                contentView: {
                    ZStack {
                        StaticUI.background
                    }
                },
                labelView: {
                    Image(systemName: "heart")
                }
            )
        }
    }
}

#Preview {
    TestTabItemView()
}
