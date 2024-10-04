//
//  BookDetail.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookDetail: View {
    var book: Book
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var selectedReadStatus: String = ""
    @State private var selectedBookshelf: String = ""
    var body: some View {
        VStack {
            BookView(bookshelfViewModel: bookshelfViewModel, book: book)
                .frame(width: 150, height: 250)
        
            VStack {
                if let title = book.title {
                    Text(title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                if let authors = book.authors {
                    Text(authors)
                        .foregroundStyle(.gray)
                }
                HStack {
                    if let book = bookshelfViewModel.currentBookPreview {
                        Picker("Read Status", selection: $selectedReadStatus) {
                            ForEach(bookshelfViewModel.shelfOptions, id: \.self) { status in
                                Text(status).tag(status)
                            }
                        }
                        .onChange(of: selectedReadStatus) { newValue in
                            book.readStatus = newValue
                        }
                        
                        Picker("Bookshelf", selection: $selectedBookshelf) {
                            ForEach(bookshelfViewModel.bookshelfOptions, id: \.self) { shelf in
                                Text(shelf).tag(shelf)
                            }
                        }
                        .onChange(of: selectedBookshelf) { newValue in
                            book.bookshelf = newValue
                        }
                    }
                }
              
            }.padding(.top, 20)
        }.onAppear {
            bookshelfViewModel.bookPreview.toggle()
            if let book = bookshelfViewModel.currentBookPreview, let bookshelf = book.bookshelf, let shelf = book.readStatus {
                selectedBookshelf = bookshelf
                selectedReadStatus = shelf
            }
     
        }
        Spacer()
    }
}

//#Preview {
//    BookDetail()
//}
