//
//  SaveBookView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 3/10/2024.
//

import SwiftUI
import FirebaseFirestore

struct SaveBookView: View {
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @ObservedObject var userViewModel: UserViewModel

    var book: Book
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20) // background
                .fill(.white)
            VStack {
                HStack {
                    Button {
                        bookshelfViewModel.bookSave.toggle() // close save popup
                    } label: {
                        Image(systemName: "xmark")
                    }.foregroundColor(.gray)
                        .font(.system(size: 20))
                        .padding(15)
                    Spacer()
                }
                Spacer()
                HStack {

                    if let book = bookshelfViewModel.currentBookSave { // if book is valid
                        BookView(book: book, inSearch: true) // shows book cover
                            .frame(width: 75, height: 105)
                            .padding(.horizontal, 10)
                        
                        VStack (alignment: .leading){
                            Text(book.getTitleFromJSON()) // shows title of book
                                .bold()
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                            Text(book.getAuthorStringFromJSON()) // shows book authors
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                VStack {
                    HStack {
                        Text("Shelf:") // lets the user change what read status they want to save the book to
                        Picker("Read status", selection: $bookshelfViewModel.selectedReadStatus) {
                            ForEach(Array(bookshelfViewModel.shelfOptions.enumerated()), id: \.0) { index, option in
                                Text(option).tag(option)
                            }
                        }
                    }
                    HStack {
                        Text("Bookshelf:") // lets the user change what owner status they want to save the book to
                        Picker("Bookshelf", selection: $bookshelfViewModel.selectedBookshelf) {
                            ForEach(Array(bookshelfViewModel.bookshelfOptions.enumerated()), id: \.0) { index, option in
                                Text(option).tag(option)
                            }
                        }
                    }
                    Button ("Save") { // saves the book, adding it to firesotre, and closing the book save popup
                        let newBook = bookshelfViewModel.add(book: book)
                        userViewModel.addBookToFirestore(book: newBook)
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
