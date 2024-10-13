//
//  Date.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import Foundation

extension Date {
    func formatted(as format: String) -> String { // allows time to be formatted
        let formatter = DateFormatter()
        formatter.dateFormat = format // specifies the format
        return formatter.string(from: self)
    }
}
