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
        print("desc", book.getDescriptionFromJSON())
        let savedBook = Book(id: book.id, title: book.getTitleFromJSON(), authors: book.getAuthorStringFromJSON(), bookshelf: selectedBookshelf, image: book.getImageThumbnailFromJSON() ?? "", readStatus: selectedReadStatus, desc: book.getDescriptionFromJSON())
        books.append(savedBook)
        return savedBook
    }
    
    func getReadImage() -> String {
        switch (currentBookPreview?.readStatus) {
        case "Unread":
            return "book.closed"
        case "Read":
            return "book.closed.fill"
        case "Reading":
            return "book"
        default:
            return ""
        }
    }
    
    func getBookshelfImage() -> String {
        switch (currentBookPreview?.bookshelf) {
        case "Owned":
            return "house"
        case "Library":
            return "building.columns"
        case "Borrowed":
            return "person.2"
        default:
            return ""
        }
    }
}
