//
//  Sound.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 13.12.2023.
//

import AVFoundation

protocol Sound {
    var url: URL? { get }
    
    func getFileName() -> String
    func getFileExtension() -> String
    
    var volume: Float { get }
    func getNumberOfLoops() -> Int
    func enableRate() -> Bool
    func getRate() -> Float
}

extension Sound {
    var url: URL? {
        Bundle.main.url(forResource: getFileName(), withExtension: getFileExtension())
    }
    
    func getFileExtension() -> String {
        SoundFileExtension.mp3.rawValue
    }
    
    func getNumberOfLoops() -> Int { 0 }
    func enableRate() -> Bool { false }
    func getRate() -> Float { 1 }
}
