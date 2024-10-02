//
//  BookshelfViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import Foundation

class BookshelfViewModel: ObservableObject{
  var books: [Book] = []
    
    func add(book: Book) {
        books.append(book)
    }
}
