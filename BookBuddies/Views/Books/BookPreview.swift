//
//  BookPreview.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookPreview: View {
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State var currentUser: User
    @State var currentUserBooks: [Book]
    @State var currentReadStatus: String = ""
    @State var currentOwnerStatus: String = ""

    var source: String
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

                        if let book = bookshelfViewModel.currentBookPreview {
                            BookView(book: book, inSearch: false)
                                .frame(width: 75, height: 105)

                                .padding(.horizontal, 10)
                            
                            VStack (alignment: .leading){
                                Text(book.title ?? "")
                                    .bold()
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .minimumScaleFactor(0.5)
                                Text(book.getAuthorString())
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                    }
                    HStack {
                        VStack (alignment: .center){
                            Image(systemName: bookshelfViewModel.getBookshelfImage())
                            Image(systemName: bookshelfViewModel.getReadImage())
                        }
                        if (source == "self") {
                            VStack(alignment: .leading) {
                                Text(bookshelfViewModel.currentBookPreview?.bookshelf ?? "")
                                Text(bookshelfViewModel.currentBookPreview?.readStatus ?? "")
                            }
                        } else {
                            VStack (alignment: .leading) {
                                Text(bookshelfViewModel.currentOwnerStatus ?? "")
                                Text(bookshelfViewModel.currentReadStatus ?? "")
                            }
                        }
                     
                       
                        Spacer()
                        NavigationLink {
                            if let book = bookshelfViewModel.currentBookPreview {
                                BookDetail(book: book, bookshelfViewModel: bookshelfViewModel)
                            }
                        } label : {
                            HStack {
                                Text("View More")
                                Image(systemName: "greaterthan")
                            }.foregroundStyle(.navy)

                        }
                    }.padding(10)
                        .font(.system(size: 15))
                        .foregroundStyle(.navy)
                    Spacer()
                }
            }.frame(width: 280, height: 160)
            .onAppear {
                if (source != "self") {
                    loadBooks()
//                    getCurrentUserStatus()
                }
            }
        
    }
    
//    func getCurrentUserStatus() {
//        if let bookPreview = bookshelfViewModel.currentBookPreview {
//            if let matchingBook = currentUserBooks.first(where: { $0.id == bookPreview.id }), let readStatus = matchingBook.readStatus, let ownerStatus = matchingBook.bookshelf {
//                   currentReadStatus = readStatus
//                   currentOwnerStatus = ownerStatus
//
//               } else {
//                   print("Book not found in user's current books.")
//               }
//           }
//       
//    }
    func loadBooks() {
            Book.loadBooksFromFirestore(user: currentUser) { fetchedBooks in
                DispatchQueue.main.async {
                    self.currentUserBooks = fetchedBooks
                }
            }
    }
}
