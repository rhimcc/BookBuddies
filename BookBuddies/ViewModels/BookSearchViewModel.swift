//
//  BookViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import Foundation

class BookSearchViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchQuery: String = "" {
        didSet { // when the search query is updated it creates a request with the new search query
            bookService.fetchBooks(keyword: searchQuery) {
                self.books = self.bookService.books // redefines the books with the searched books
            }
        }
    }
    @Published var searchActive: Bool = false
     var bookService: BookService = BookService()

}
