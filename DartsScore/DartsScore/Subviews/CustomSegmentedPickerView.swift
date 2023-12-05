//
//  CustomSegmentedPickerView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import SwiftUI

struct CustomSegmentedPickerView<T: Hashable>: View {
    let data: [T]
    @Binding var selectedItem: T
    let toText: (T) -> String
    
    init(_ data: [T], _ selectedItem: Binding<T>, toText: @escaping (T) -> String) {
        self.data = data
        _selectedItem = selectedItem
        self.toText = toText
        
        // Sets the background color of the Picker
        UISegmentedControl.appearance().backgroundColor = UIColor(Palette.btnPrimary.opacity(0.25))
        
        // Disappears the divider
        UISegmentedControl.appearance().setDividerImage(UIImage(),
                                                        forLeftSegmentState: .normal,
                                                        rightSegmentState: .normal,
                                                        barMetrics: .default)
        
        // Changes the color for the selected item
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Palette.btnPrimary)
        
        // Changes the text color for the selected item
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(Palette.btnPrimaryText),
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ], for: .selected)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor(Palette.bgText.opacity(0.75)),
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ], for: .normal)
    }
    
    var body: some View {
        ZStack {
            Picker("How many cups", selection: $selectedItem) {
                ForEach(data, id: \.self) { item in
                    Text(toText(item))
                }
            }
            .frame(minHeight: 32)
            .tint(.red)
            .pickerStyle(.segmented)
        }
    }
}

struct CustomPickerView_Previews: PreviewProvider {
    @State static var selectedItem = 5
    static var previews: some View {
        CustomSegmentedPickerView([5, 10, 13, 15, 17, 30], $selectedItem) { "\($0)" }
    }
}
