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
    @Published var currentBookPreview: Book? = nil // variable to store the book which is in the preview popup
    @Published var bookPreview: Bool = false // bool for popup
    @Published var bookSave: Bool = false // bool for popup
    @Published var currentBookSave: Book? = nil // variable to store the book which is in the save popup
    @Published var selectedReadStatus: String = "Read" // Used in picker
    @Published var selectedBookshelf: String = "Owned" // Used in picker
    @Published var currentBookshelf: String = "Owned" // specifying the bookshelf which is being shown
    @Published var bookColors: [String: Color] = [:] // Dictionary to hold colors for each book
    @Published var currentUserBooks: [Book] = [] // the books from the current user
    @Published var currentReadStatus: String = "" // the read status of the current user
    @Published var currentOwnerStatus: String = "" // the owner status of the current user


    var bookshelfOptions: [String] = ["Owned", "Library", "Borrowed"] // options for each bookshelf
    var shelfOptions: [String] = ["Reading", "Unread", "Read"] // options for each shelf
    
    func getCurrentUserStatus() { // gets the status of the current suer
        if let bookPreview = currentBookPreview {
            if let matchingBook = currentUserBooks.first(where: { $0.id == bookPreview.id }), let readStatus = matchingBook.readStatus, let ownerStatus = matchingBook.bookshelf { // gets the book instance from the array, if applicable, and gets the status
                   currentReadStatus = readStatus
                   currentOwnerStatus = ownerStatus + " by You"

               } else { // if there is no matching book in the current users array
                   currentReadStatus = "--"
                   currentOwnerStatus = "Not Owned by You"
               }
           }
       
    }
    
    func add(book: Book) -> Book{
        let savedBook = Book(id: book.id, title: book.getTitleFromJSON(), authors: book.getAuthorStringFromJSON(), bookshelf: selectedBookshelf, image: book.getImageThumbnailFromJSON() ?? "", readStatus: selectedReadStatus, desc: book.getDescriptionFromJSON(), pageCount: book.getPageCount(), userPage: getUserPage(book: book)) // creates book instance from the searched books
        return savedBook
    }
    
    func getUserPage(book: Book) -> Int { // gets the page count from the book if the user has read it, and if not, it returns 0 for unread/reading status
        if selectedReadStatus == "Read" {
            return book.getPageCount()
        }
        return 0
    }
    
    static func getReadImage(readStatus: String) -> String { // cases for each read status to return strings used for images
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
    
    static func getBookshelfImage(bookshelf: String) -> String { // cases for each owner status to return strings used for images
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
    
    static func getBooks() -> [Book] { // returns books
        return books
    }
    
    func getBookTotal() -> Int { // gets the total amount of books that the user has
        return currentUserBooks.count
    }
    
    func getBooksRead() -> Int { // gets the amoutn of books which the user has read
        let newArray = currentUserBooks.filter{$0.readStatus == "Read"}
        return newArray.count
    }
}

