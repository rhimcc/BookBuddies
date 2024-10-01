//
//  BookViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchQuery: String = "" {
        didSet {
            bookService.fetchBooks(keyword: searchQuery) {
                self.books = self.bookService.books
            }
        }
    }
    
    @Published var searchActive: Bool = false

     var bookService: BookService = BookService()
}
