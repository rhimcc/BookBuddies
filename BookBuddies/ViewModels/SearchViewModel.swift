//
//  SearchViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = "" // stores the search query
    @Published var isActive: Bool = false // stores the active status of the search
}
