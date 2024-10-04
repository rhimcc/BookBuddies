//
//  SaveBookView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 3/10/2024.
//

import SwiftUI

struct SaveBookView: View {
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @Environment(\.modelContext) private var modelContext

    
    var book: Book
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
            VStack {
                HStack {
                    Button {
                        bookshelfViewModel.bookPreview.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }.foregroundColor(.gray)
                        .font(.system(size: 20))
                        .padding(15)
                    Spacer()
                }
                Spacer()
                HStack {

                    if let book = bookshelfViewModel.currentBookSave {
                        BookView(bookshelfViewModel: bookshelfViewModel, book: book)
                            .padding(.horizontal, 10)
                        
                        VStack (alignment: .leading){
                            Text(book.getTitleFromJSON())
                                .bold()
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                            Text(book.getAuthorStringFromJSON())
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                VStack {
                    HStack {
                        Text("Shelf:")
                        Picker("Read status", selection: $bookshelfViewModel.selectedReadStatus) {
                            ForEach(Array(bookshelfViewModel.shelfOptions.enumerated()), id: \.0) { index, option in
                                Text(option).tag(option)
                            }
                        }
                    }
                    HStack {
                        Text("Bookshelf:")
                        Picker("Bookshelf", selection: $bookshelfViewModel.selectedBookshelf) {
                            ForEach(Array(bookshelfViewModel.bookshelfOptions.enumerated()), id: \.0) { index, option in
                                Text(option).tag(option)
                            }
                        }
                    }
                    Button ("Save") {
                        let newBook = bookshelfViewModel.add(book: book)
                        modelContext.insert(newBook)
                        newBook.printBook()
                        bookshelfViewModel.bookSave.toggle()
                    }
                }
                Spacer()
            }
        }.frame(width: 280, height: 160)
    
    }
        
}


//#Preview {
//    SaveBookView()
//}
