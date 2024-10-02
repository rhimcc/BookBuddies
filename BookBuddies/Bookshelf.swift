//
//  Bookshelf.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI
import SwiftData

struct Bookshelf: View {
    @Query var books: [Book]
    @State var bookInfo: Bool = false
    @State var currentBook: Book?
    var body: some View {
        
        ZStack {
            BookshelfBackground()
            ForEach(books) { book in
                Button {
                    bookInfo.toggle()
                    currentBook = book
                } label : {
                    BookView(book: book)
                }
                

            }
            if bookInfo { // fades the background a bit to take focus off the surrounding information
                if let book = currentBook {
                    BookPreview(book: book)

                }
            
            }
        }
        
    }
}

#Preview {
    Bookshelf()
}
