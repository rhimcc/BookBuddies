//
//  BookshelfViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import Foundation
import SwiftUI

class BookshelfViewModel: ObservableObject{
  var books: [Book] = []
    var inSearch: Bool = false
    @Published var currentBookPreview: Book? = nil
    @Published var bookPreview: Bool = false
    @Published var bookSave: Bool = false
    @Published var currentBookSave: Book? = nil
    @Published var selectedReadStatus: String = "Read"
    @Published var selectedBookshelf: String = "Owned"
    @Published var currentBookshelf: String = "Owned"
    @Published var bookColors: [String: Color] = [:] // Dictionary to hold colors for each book

    var bookshelfOptions: [String] = ["Owned", "Library", "Borrowed"]
    var shelfOptions: [String] = ["Read", "Reading", "Unread"]
    
    func add(book: Book) -> Book{
        let savedBook = Book(id: book.id, title: book.getTitleFromJSON(), authors: book.getAuthorStringFromJSON(), bookshelf: selectedBookshelf, image: book.getImageThumbnailFromJSON() ?? "", readStatus: selectedReadStatus)
        books.append(savedBook)
        return savedBook
    }
}
