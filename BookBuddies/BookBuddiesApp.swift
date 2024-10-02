//
//  BookBuddiesApp.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI
import SwiftData

@main
struct BookBuddiesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
