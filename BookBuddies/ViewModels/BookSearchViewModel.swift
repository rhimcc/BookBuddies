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
        didSet {
            bookService.fetchBooks(keyword: searchQuery) {
                self.books = self.bookService.books
            }
        }
    }
    
    @Published var searchActive: Bool = false

     var bookService: BookService = BookService()
    
    func convertURL(book: Book) -> String {
        var imageURL: String = ""
        imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
        return imageURL
    }
}
