//
//  DartsGameResultsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 01.12.2023.
//

import SwiftUI

final class DartsGameResultsViewModel: ObservableObject {
    @Published private(set) var model: DartsGameStats
    
    init() {
        model = DartsGameResultsViewModel.getModel()
    }
    
    func refresh() {
        model = DartsGameResultsViewModel.getModel()
    }
    
    private static func getModel() -> DartsGameStats {
        if isPreview {
            return MockData.getDartsGameStats()
        } else {
            return JsonCache.loadDartsGameStats(from: AppSettings.statsJsonFileName)
        }
    }
    
    func getGame(_ idx: String) -> DartsGame? {
        model.items.first { $0.id == idx }
    }
}
