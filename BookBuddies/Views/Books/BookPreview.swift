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
    @ObservedObject var userViewModel: UserViewModel
    var source: String
    var bookshelfOwner: User

    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                VStack {
                    HStack {
                        Button {
                            bookshelfViewModel.bookPreview.toggle() // closes book preview
                        } label: {
                            Image(systemName: "xmark")
                        }.foregroundColor(.gray)
                            .font(.system(size: 20))
                            .padding(15)
                        Spacer()
                    }
                    Spacer()
                    HStack {

                        if let book = bookshelfViewModel.currentBookPreview { // gets book which is previewed
                            BookView(book: book, inSearch: false)
                                .frame(width: 70)
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 20)
                            Spacer().frame(width: 10)
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
                            }.frame(alignment: .leading)
                        }
                    }.frame(width: 280, alignment: .leading)
                    HStack { // icons and text for the owner/read status
                        VStack (alignment: .center){
                            if let book = bookshelfViewModel.currentBookPreview, let bookshelf = book.bookshelf, let readStatus = book.readStatus {
                                Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: bookshelf))
                                Image(systemName: BookshelfViewModel.getReadImage(readStatus: readStatus))
                            }
                        }
                        if (source == "self") {
                            VStack(alignment: .leading) {
                                if let book = bookshelfViewModel.currentBookPreview, let bookshelf = book.bookshelf, let readStatus = book.readStatus {
                                    Text(bookshelf)
                                    Text(readStatus)
                                }
                            }
                        } else {
                            VStack (alignment: .leading) {
                                Text(bookshelfViewModel.currentOwnerStatus)
                                Text(bookshelfViewModel.currentReadStatus)
                            }
                        }
                     
                       
                        Spacer()
                        NavigationLink { // button to show details of book
                            if let book = bookshelfViewModel.currentBookPreview {
                                BookDetail(currentUser: currentUser, book: book, bookshelfViewModel: bookshelfViewModel, userViewModel: userViewModel, source: source)
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
                }
            }
        
    }

    func loadBooks() { // loads books
            userViewModel.loadBooksFromFirestore(user: currentUser) { fetchedBooks in
                DispatchQueue.main.async {
                    self.currentUserBooks = fetchedBooks
                }
            }
    }
}
