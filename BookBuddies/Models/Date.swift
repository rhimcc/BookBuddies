//
//  Date.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import Foundation

extension Date {
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
