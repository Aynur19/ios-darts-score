//
//  UInt64Ext.swift
//  DartsScore
//
//  Created by Aynur Nasybullin on 2023.11.22.
//

import Foundation

extension UInt64 {
    static func nanoseconds(from seconds: Self) -> Self {
        seconds * 1_000_000_000
    }
}
