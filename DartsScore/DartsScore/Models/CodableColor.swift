//
//  CodableColor.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 09.12.2023.
//

import SwiftUI

struct CodableColor: Equatable {
    private(set) var red: Double    = 0
    private(set) var green: Double  = 0
    private(set) var blue: Double   = 0
    private(set) var alpha: Double  = 0
    
    init(_ color: Color) {
        if let components = color.components {
            red     = components.r
            green   = components.g
            blue    = components.b
            alpha   = components.a
        } else {
            setColorComponents(UIColor(color))
        }
    }
    
    init(uiColor: UIColor) {
        setColorComponents(uiColor)
    }
    
    private mutating func setColorComponents(_ uiColor: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        red     = r
        green   = g
        blue    = b
        alpha   = a
    }
    
    func toColor() -> Color {
        .init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    func toUIColor() -> UIColor {
        .init(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
}

extension CodableColor: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.red    = try container.decode(Double.self, forKey: .red)
        self.green  = try container.decode(Double.self, forKey: .green)
        self.blue   = try container.decode(Double.self, forKey: .blue)
        self.alpha  = try container.decode(Double.self, forKey: .alpha)
    }

    private enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
        case alpha
    }
}
