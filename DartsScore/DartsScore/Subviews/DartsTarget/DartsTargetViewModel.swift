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
}
