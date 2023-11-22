//
//  DartsSectorPath.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.23.
//

import SwiftUI

struct SectorPath: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: innerRadius * cos(CGFloat(startAngle.radians)),
                              y: innerRadius * sin(CGFloat(startAngle.radians))))
        
        path.addArc(center: .zero,
                    radius: outerRadius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: outerRadius * cos(CGFloat(endAngle.radians)),
                                 y: outerRadius * sin(CGFloat(endAngle.radians))))
        
        path.addArc(center: .zero,
                    radius: innerRadius,
                    startAngle: endAngle,
                    endAngle: startAngle,
                    clockwise: true)
        
        return path
    }
}

#Preview {
    VStack {
        SectorPath(startAngle: Angle(degrees: 0),
                   endAngle: Angle(degrees: 18),
                   innerRadius: 0,
                   outerRadius: 50)
        .fill(Color.red)
        .frame(width: 100, height: 100)
    }
}
