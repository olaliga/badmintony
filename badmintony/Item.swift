//
//  Item.swift
//  badmintony
//
//  Created by 黃仕傑 on 2025/5/6.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
