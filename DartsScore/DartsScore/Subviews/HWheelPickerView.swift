//
//  HWheelPickerView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 03.12.2023.
//

import SwiftUI
import Combine

struct HWheelPickerView<DataType, ContentType, DividerType, BackgroundType, MaskType>: View
where DataType: Hashable,
      ContentType: View,
      DividerType: View,
      BackgroundType: View,
      MaskType: View {
    
    private let preferenceName = "scrollOffset"
    
    private let data: [DataType]
    @Binding var selectedItemIdx: Int
    
    private let contentSize: CGSize
    private let dividerSize: CGSize
    
    private let contentView: (DataType) -> ContentType
    private let dividerView: () -> DividerType
    
    private let backgroundView: () -> BackgroundType
    private let maskView: () -> MaskType
    
    @State private var xOffset: CurrentValueSubject<CGFloat, Never>
    @State private var publisher: AnyPublisher<CGFloat, Never>
    
    init(
        _ data: [DataType],
        _ selectedItemIdx: Binding<Int>,
        contentSize: CGSize = .init(width: 64, height: 32),
        dividerSize: CGSize = .init(width: 2, height: 20),
        contentView: @escaping (DataType) -> ContentType,
        dividerView: @escaping () -> DividerType,
        backgroundView: @escaping () -> BackgroundType,
        maskView: @escaping () -> MaskType
    ) {
        self.data = data
        _selectedItemIdx = selectedItemIdx
        
        self.contentView = contentView
        self.dividerView = dividerView
        
        self.contentSize = contentSize
        self.dividerSize = dividerSize
        
        self.backgroundView = backgroundView
        self.maskView = maskView
        
        let xOffset = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = xOffset
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        
        self.xOffset = xOffset
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                hScrollView(geometry, scrollProxy)
                    .coordinateSpace(name: preferenceName)
                    .onAppear {
                        DispatchQueue.main.async {
                            scrollProxy.scrollTo(selectedItemIdx, anchor: .center)
                        }
                    }
                    .onReceive(publisher) { offset in
                        scrollTo(offset, scrollProxy)
                    }
                    .background { backgroundView() }
                    .mask { maskView() }
            }
        }
    }
    
    private var scrollItems: some View {
        ForEach(data.indices, id: \.self) { itemIdx in
            HStack(spacing: .zero) {
                dividerView()
                    .frame(width: dividerSize.width, height: dividerSize.height)
                
                contentView(data[itemIdx])
                    .frame(width: contentSize.width, height: contentSize.height)
                
                if itemIdx == data.count - 1 {
                    dividerView()
                        .frame(width: dividerSize.width, height: dividerSize.height)
                }
            }
        }
    }
    
    private func scrollTo(_ offset: CGFloat, _ scrollProxy: ScrollViewProxy) {
        var idx = Int((offset / itemWidth()).rounded(.down))
        
        if idx >= data.count {
            idx = data.count - 1
        }
        selectedItemIdx = idx
        
        withAnimation {
            scrollProxy.scrollTo(idx, anchor: .center)
        }
    }
    
    private func itemWidth() -> CGFloat {
        contentSize.width + dividerSize.width
    }
    
    private func hScrollView(_ geometry: GeometryProxy, _ scrollProxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .zero) {
                Spacer(minLength: geometry.size.width.half)
                scrollItems
                Spacer(minLength: geometry.size.width.half)
            }
            .background {
                GeometryReader {
                    Color.clear.preference(
                        key: ScrollViewOffsetKey.self,
                        value: -$0.frame(in: .named(preferenceName)).origin.x
                    )
                }
            }
        }
        .onPreferenceChange(ScrollViewOffsetKey.self) {
            xOffset.send($0)
        }
    }
}

struct CustomWheelPickerView_Previews: PreviewProvider {
    static let data = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    @State static var selectedItemIdx = 5
    
    static var previews: some View {
        VStack {
            Text("\(selectedItemIdx)")
            HWheelPickerView(data, $selectedItemIdx) { item in
                Text("\(item)")
                    .font(.headline)
                    .foregroundStyle(Palette.btnPrimary)
            } dividerView: {
                Palette.btnPrimary
            } backgroundView: {
                LinearGradient(
                    colors: [.clear, Palette.btnPrimary.opacity(0.25), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            } maskView: {
                LinearGradient(
                    colors: [.clear, Palette.btnPrimary, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
        }
    }
}
