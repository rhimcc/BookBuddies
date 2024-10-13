//
//  BookshelfViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import Foundation
import SwiftUI

class BookshelfViewModel: ObservableObject{
    static var books: [Book] = []
    var inSearch: Bool = false
    @Published var currentBookPreview: Book? = nil
    @Published var bookPreview: Bool = false
    @Published var bookSave: Bool = false
    @Published var currentBookSave: Book? = nil
    @Published var selectedReadStatus: String = "Read"
    @Published var selectedBookshelf: String = "Owned"
    @Published var currentBookshelf: String = "Owned"
    @Published var bookColors: [String: Color] = [:] // Dictionary to hold colors for each book
    @Published var currentUserBooks: [Book] = []
    @Published var currentReadStatus: String = ""
    @Published var currentOwnerStatus: String = ""


    var bookshelfOptions: [String] = ["Owned", "Library", "Borrowed"]
    var shelfOptions: [String] = ["Reading", "Unread", "Read"]
    
    func getCurrentUserStatus() {
        if let bookPreview = currentBookPreview {
            if let matchingBook = currentUserBooks.first(where: { $0.id == bookPreview.id }), let readStatus = matchingBook.readStatus, let ownerStatus = matchingBook.bookshelf {
                   currentReadStatus = readStatus
                   currentOwnerStatus = ownerStatus + " by You"

               } else {
                   currentReadStatus = "--"
                   currentOwnerStatus = "Not Owned by You"
               }
           }
       
    }
    
    func add(book: Book) -> Book{
        let savedBook = Book(id: book.id, title: book.getTitleFromJSON(), authors: book.getAuthorStringFromJSON(), bookshelf: selectedBookshelf, image: book.getImageThumbnailFromJSON() ?? "", readStatus: selectedReadStatus, desc: book.getDescriptionFromJSON(), pageCount: book.getPageCount(), category: book.getCategoryFromJSON(), userPage: getUserPage(book: book))
        return savedBook
    }
    
    func getUserPage(book: Book) -> Int {
        if selectedReadStatus == "Read" {
            return book.getPageCount()
        }
        return 0
    }
    
    static func getReadImage(readStatus: String) -> String {
        switch (readStatus) {
        case "Unread":
            return "book.closed"
        case "Read":
            return "book.closed.fill"
        case "Reading":
            return "book"
        default:
            return "book.closed"
        }
    }
    
    static func getBookshelfImage(bookshelf: String) -> String {
        switch (bookshelf) {
        case "Owned":
            return "house"
        case "Library":
            return "building.columns"
        case "Borrowed":
            return "person.2"
        default:
            return "house"
        }
    }
    
    static func getBooks() -> [Book] {
        return books
    }
    
    func getBookTotal() -> Int {
        return currentUserBooks.count
    }
    
    func getBooksRead() -> Int {
        let newArray = currentUserBooks.filter{$0.readStatus == "Read"}
        return newArray.count
    }
}

