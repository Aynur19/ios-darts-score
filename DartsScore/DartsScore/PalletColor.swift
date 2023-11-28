//
//  PalletColor.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 28.11.2023.
//

import SwiftUI

enum PalletColor {
    case dark1
    
    var background: Color {
        switch self {
            case .dark1: Color("DarkBackground1")
        }
    }
    
    var textColor: Color {
        switch self {
            case .dark1: Color("DarkText1")
        }
    }
}
