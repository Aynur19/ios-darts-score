//
//  HSegmentedPickerView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct HSegmentedPickerView<DataType, ContentType>: View
where DataType: Hashable, ContentType: View {
    
    let data: [DataType]
    @Binding var selectedItem: DataType
    
    let contentView: (DataType) -> ContentType
    
    init(
        _ data: [DataType],
        _ selectedItem: Binding<DataType>,
        backgroundColor: UIColor = .gray.withAlphaComponent(0.25),
        selectedSegmentTintColor: UIColor = .gray.withAlphaComponent(0.75),
        selectedForecroundColor: UIColor = .white,
        normalForegroundColor: UIColor = .white.withAlphaComponent(0.75),
        textStyle: UIFont.TextStyle = .headline,
        contentView: @escaping (DataType) -> ContentType
    ) {
        self.data = data
        _selectedItem = selectedItem
        
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

private struct TestHSegmentedPickerView: View {
    let data = [5, 10, 13, 15, 17, 30]
    @State private var selectedItem = 5
    
    var body: some View {
        HSegmentedPickerView(
            data,
            $selectedItem,
            backgroundColor: UIColor(Palette.btnPrimary.opacity(0.25)),
            selectedSegmentTintColor: UIColor(Palette.btnPrimary),
            selectedForecroundColor: UIColor(Palette.btnPrimaryText),
            normalForegroundColor: UIColor(Palette.bgText.opacity(0.75))
        ) { item in
            Text("\(item)")
        }
    }
}

struct HSegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TestHSegmentedPickerView()
    }
}
