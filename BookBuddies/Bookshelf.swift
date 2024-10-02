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
    var bookshelfViewModel: BookshelfViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                BookshelfBackground()
                HStack {
                    ForEach(books) { book in
                        Button {
                            bookshelfViewModel.bookPreview.toggle()
                            currentBook = book
                        } label : {
                            BookView(bookshelfViewModel: bookshelfViewModel, book: book)
                        }
                    }
                    
                    
                }
                if bookshelfViewModel.bookPreview {
                    if let book = currentBook {
                        BookPreview(bookshelfViewModel: bookshelfViewModel, book: book)
                    }
                }
            }.onAppear {
                bookshelfViewModel.inSearch = false
            }
            
        }
    }
}
//
//#Preview {
//    Bookshelf()
//}
