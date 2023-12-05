//
//  AppSettingsViewModel.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 02.12.2023.
//

import Foundation

final class AppSettingsViewModel: ObservableObject {
    @Published private(set) var attemptsCount = AppSettings.attemptsCountData[2]
    @Published private(set) var timeForAnswer = 5
}
