//
//  EnvironmentKVO.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 26.12.2023.
//

import SwiftUI

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
    
    var dartsTargetSize: CGFloat {
        get { self[DartsTargetSizeKey.self] }
        set { self[DartsTargetSizeKey.self] = newValue }
    }
}

private struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

private struct DartsTargetSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 350
}
