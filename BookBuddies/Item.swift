//
//  Item.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
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
