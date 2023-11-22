//
//  CGPointExt.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

extension CGPoint {
    static var center: Self {
        .init(x: UIScreen.main.bounds.midX,
              y: UIScreen.main.bounds.midY)
    }
    
    static func getCenter(from geometry: GeometryProxy) -> CGPoint {
        .init(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
    
    static func toLocal(center: CGPoint, globalPoint: CGPoint) -> CGPoint {
        .init(x: globalPoint.x - center.x, y: -(globalPoint.y - center.y))
    }
    
    static func toGlobal(center: CGPoint, localPoint: CGPoint) -> CGPoint {
        .init(x: localPoint.x + center.x, y: center.y - localPoint.y)
    }
    
    static func distance(from start: CGPoint = .zero, to end: CGPoint) -> CGFloat {
        sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
    }
    
    static func radiusPoint(center: CGPoint, radius: CGFloat, angle: Angle) -> Self {
        .init(x: center.x + CoreGraphics.cos(angle.radians) * radius,
              y: center.y + CoreGraphics.sin(angle.radians) * radius)
    }
    
    func toStr(_ format: String = "%.02f") -> String {
        "(x: \(String(format: format, self.x)); y: \(String(format: format, self.y)))"
    }
}
