//
//  BookshelfViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import Foundation

class BookshelfViewModel: ObservableObject{
  var books: [Book] = []
    var bookshelfOptions: [String] = ["Library, Owned"]
    @Published var bookPreview: Bool = false
    
    func add(book: Book) -> Book{
        let savedBook = Book(id: book.id, title: book.getTitle(), authors: book.getAuthorString(), bookshelf: "", image: book.getImageThumbnail(), readStatus: "")
        books.append(savedBook)
        return savedBook
    }
}
