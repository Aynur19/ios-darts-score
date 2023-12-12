//
//  DartsTargetPalette.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 09.12.2023.
//

import SwiftUI

enum DartsTargetPalette: String {
    case classic
    
    var points25Color: Color {
        switch self {
            case .classic: return .green
        }
    }
    
    var bullEyeColor: Color {
        switch self {
            case .classic: return .red
        }
    }
    
    var wireColor: Color {
        switch self {
            case .classic: return .gray
        }
    }
    
    var baseColors: [Color] {
        switch self {
            case .classic: return [.white, .black]
        }
    }
    
    var xColors: [Color] {
        switch self {
            case .classic: return [.red, .green]
        }
    }
    
    var dartsSectorNumberColor: Color {
        switch self {
            case .classic: return .white
        }
    }
    
    func getSectorColor(for sectorIdx: Int, _ isBaseSector: Bool = true) -> Color {
        isBaseSector ? baseColors[sectorIdx % 2] : xColors[sectorIdx % 2]
    }
}
