//
//  DartsGameStatsView.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import SwiftUI

class DartsGameStatsViewModel: ObservableObject {
    @Published private(set) var model: DartsGameStats
    
    private let jsonCache: JsonCache<DartsGameStats>
    
    init() {
        jsonCache = .init()
        model = (try? JsonCache<DartsGameStats>.load(from: AppSettings.statsJsonFileName)) ?? .init()
    }
}

struct DartsGameStatsView: View {
    @ObservedObject var statsVM: DartsGameStatsViewModel
    
    init(statsVM: DartsGameStatsViewModel = .init()) {
        self.statsVM = statsVM
    }
    
    var body: some View {
        VStack {
            List(statsVM.model.items) { gameStats in
                Text("Score: \(gameStats.score)")
            }
        }
    }
}

#Preview {
    DartsGameStatsView()
}
