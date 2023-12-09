//
//  ScrollViewOffsetKey.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 09.12.2023.
//

import SwiftUI

struct ScrollViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
