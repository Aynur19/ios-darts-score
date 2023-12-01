//
//  DartsGameAnswersViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 01.12.2023.
//

import SwiftUI

final class DartsGameAnswersViewModel: ObservableObject {
    let game: DartsGame
    let model: DartsGameSnapshotsList
    
    init(_ game: DartsGame) {
        self.game = game
        self.model = DartsGameAnswersViewModel.getModel(game)
    }
    
    private static func getModel(_ game: DartsGame) -> DartsGameSnapshotsList {
        if isPreview {
            return MockData.getDartsGameSnapshotsList()
        }
        
        return JsonCache.loadGameSnapshotsList(from: game.snapshotsJsonName, gameId: game.id)
    }
}
