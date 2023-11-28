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
            case .dark1: Color("Dark1 Background")
        }
    }
    
    var bgTextColor: Color {
        switch self {
            case .dark1: Color("Dark1 Background Text")
        }
    }
    
    var btnPrimaryColor: Color {
        switch self {
            case .dark1: Color("Dark1 Btn Primary")
        }
    }
    
    var btnPrimaryTextColor: Color {
        switch self {
            case .dark1: Color("Dark1 Btn Primary Text")
        }
    }
    
    var btnSecondaryColor: Color {
        switch self {
            case .dark1: Color("Dark1 Btn Secondary")
        }
    }
    
    var btnSecondaryTextColor: Color {
        switch self {
            case .dark1: Color("Dark1 Btn Secondary Text")
        }
    }
    
    var optionsColor1: Color {
        switch self {
            case .dark1: Color("Dark1 Options1")
        }
    }
    
    var optionsTextColor1: Color {
        switch self {
            case .dark1: Color("Dark1 Options1 Text")
        }
    }
    
    var optionsColor2: Color {
        switch self {
            case .dark1: Color("Dark1 Options2")
        }
    }
    
    var optionsTextColor2: Color {
        switch self {
            case .dark1: Color("Dark1 Options2 Text")
        }
    }
}
