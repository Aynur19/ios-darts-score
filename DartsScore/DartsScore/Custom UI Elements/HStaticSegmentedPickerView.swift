//
//  HStaticSegmentedPickerView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct HStaticSegmentedPickerView<DataType, ContentViewType>: View
where DataType: Hashable,
      ContentViewType: View {
    
    let data: [DataType]
    @Binding var selectedItem: DataType
    
    @ViewBuilder private var contentView: (DataType) -> ContentViewType
    
    init(
        data: [DataType],
        value: Binding<DataType>,
        backgroundColor: UIColor = .gray.withAlphaComponent(0.25),
        selectedSegmentTintColor: UIColor = .gray.withAlphaComponent(0.75),
        selectedForecroundColor: UIColor = .white,
        normalForegroundColor: UIColor = .white.withAlphaComponent(0.75),
        textStyle: UIFont.TextStyle = .headline,
        @ViewBuilder contentView: @escaping (DataType) -> ContentViewType
    ) {
        self.data = data
        _selectedItem = value
        
        self.contentView = contentView
        
        UISegmentedControl.appearance().backgroundColor = backgroundColor
        
        UISegmentedControl.appearance().setDividerImage(
            .init(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .compact
        )
        
        UISegmentedControl.appearance().selectedSegmentTintColor = selectedSegmentTintColor
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: selectedForecroundColor,
            .font: UIFont.preferredFont(forTextStyle: textStyle)
        ], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: normalForegroundColor,
            .font: UIFont.preferredFont(forTextStyle: textStyle)
        ], for: .normal)
        
    }
    
    var body: some View {
        ZStack {
            Picker("", selection: $selectedItem) {
                ForEach(data, id: \.self) { item in
                    contentView(item)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

private struct TestHStaticSegmentedPickerView: View {
    let data = [5, 10, 13, 15, 17, 30]
    @State private var selectedItem = 5
    
    var body: some View {
        VStack {
            Picker("Options", selection: $selectedItem) {
                ForEach(data, id: \.self) { item in
                    Text("\(item)")
                }
            }
            .pickerStyle(.segmented)
            
            HStaticSegmentedPickerView(
                data: data,
                value: $selectedItem,
                contentView: { item in
                    Text("\(item)")
                }
            )
            
            HStaticSegmentedPickerView(
                data: data,
                value: $selectedItem,
                backgroundColor: UIColor(Palette.btnPrimary.opacity(0.25)),
                selectedSegmentTintColor: UIColor(Palette.btnPrimary),
                selectedForecroundColor: UIColor(Palette.btnPrimaryText),
                normalForegroundColor: UIColor(Palette.bgText.opacity(0.75))
            ) { item in
                Text("\(item)")
            }
        }
    }
}

#Preview {
    TestHStaticSegmentedPickerView()
}
