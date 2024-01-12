//
//  DartsTargetViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 16.12.2023.
//

import Foundation

final class DartsTargetViewModel: ObservableObject {
    @Published private(set) var model: DartsTarget
    
    init(frameWidth: CGFloat) {
        model = .init(frameWidth: frameWidth)
    }
    
    func reset(frameWidth: CGFloat) {
        model.update(frameWidth: frameWidth)
    }
    
    lazy var numbersDistance: CGFloat = {
        model.maxRadius * DartsConstants.symbolsDistanceCoef
    }()
    
    func getInnerRadiuses(_ isBaseSector: Bool) -> [CGFloat] {
        var result = [CGFloat]()
        
        result.append(isBaseSector ? model.points25Radius : model.baseSmallRadius)
        result.append(isBaseSector ? model.x3Radius : model.baseBigRadius)
        
        return result
    }
    
    func getOutherRadiuses(_ isBaseSector: Bool) -> [CGFloat] {
        var result = [CGFloat]()
        
        result.append(isBaseSector ? model.baseSmallRadius : model.x3Radius)
        result.append(isBaseSector ? model.baseBigRadius : model.x2Radius)
        
        return result
    }
}
