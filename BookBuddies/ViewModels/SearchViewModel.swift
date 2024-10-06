//
//  SearchViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var isActive: Bool = false
}
