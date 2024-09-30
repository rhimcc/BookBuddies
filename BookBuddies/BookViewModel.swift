//
//  BookViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import Foundation

class BookViewModel: ObservableObject {
    @Published var searchQuery: String = "" {
        didSet {
            bookService.fetchBook(keyword: searchQuery)
        }
    }
    
    @Published var searchActive: Bool = false
    var bookService: BookService = BookService()
}
