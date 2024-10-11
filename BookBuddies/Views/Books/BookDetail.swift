//
//  BookDetail.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookDetail: View {
    var currentUser: User?
    var bookshelfOwner: User?
    var book: Book
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var selectedReadStatus: String = ""
    @State private var selectedBookshelf: String = ""
    @ObservedObject var userViewModel: UserViewModel
    @State var userStatuses: [String: [String]] = [:]
    var body: some View {
        ZStack {
            Color.veryLightPeach
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                BookView(book: book, inSearch: false)
                    .frame(width: 150, height: 250)
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    .padding(.top, 10)
                
                VStack {
                    if let title = book.title {
                        Text(title)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                    if let authors = book.authors {
                        Text(authors)
                            .foregroundStyle(.navy)
                    }
                    LineView()
                    if let book = bookshelfViewModel.currentBookPreview {
                        VStack {
                            HStack (alignment: .center) {
                                Image(systemName: bookshelfViewModel.getBookshelfImage())
                                Picker("Bookshelf", selection: $selectedBookshelf) {
                                    ForEach(bookshelfViewModel.bookshelfOptions, id: \.self) { shelf in
                                        Text(shelf).tag(shelf)
                                            .bold()
                                    }
                                }
                                .onChange(of: selectedBookshelf) { newValue in
                                    book.bookshelf = newValue
                                }
                                Spacer()
                                Image(systemName: bookshelfViewModel.getReadImage())
                                Picker("Read Status", selection: $selectedReadStatus) {
                                    ForEach(bookshelfViewModel.shelfOptions, id: \.self) { status in
                                        Text(status).tag(status)
                                    }
                                }
                                .onChange(of: selectedReadStatus) { newValue in
                                    book.readStatus = newValue
                                }
                            }.padding(.horizontal, 30)
                            
                            LineView()
                        } .padding(.top, 20)
                            .onAppear {
                                bookshelfViewModel.bookPreview.toggle()
                                if let book = bookshelfViewModel.currentBookPreview, let bookshelf = book.bookshelf, let shelf = book.readStatus {
                                    selectedBookshelf = bookshelf
                                    selectedReadStatus = shelf
                                }
                                
                            }
                    }
//                        if let book = bookshelfViewModel.currentBookPreview {
//                            HStack (alignment: .center) {
//                                Image(systemName: bookshelfViewModel.getBookshelfImage())
//                                Text(book.readStatus ?? "")
//                                
//                                Spacer()
//                                Image(systemName: bookshelfViewModel.getReadImage())
//                                Text(book.bookshelf ?? "")
//                                
//                            }.padding(.horizontal, 30)
//                        }
//                    }
                    
                    VStack {
                        Text("Book Description")
                            .bold()
                            .padding(.vertical, 5)
                        if let desc = book.desc {
                            Text(desc)
                                .frame(alignment: .center)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                    LineView()
                    
                    if (userViewModel.friends.count > 0) {
                        Text("Friends")
                            .bold()
                    }
                    VStack {
                        ForEach(userViewModel.friends) { friend in
                            HStack {
                                
                                if let array = userStatuses[friend.id] {
                                    Text(friend.displayName)
                                        .bold()
                                    Spacer()
                                    VStack (alignment: .trailing){
                                        Text(array[0])
                                        Text(array[1])
                                    }
                                        VStack (alignment: .center){
                                            Image(systemName: bookshelfViewModel.getBookshelfImage())
                                            Image(systemName: bookshelfViewModel.getReadImage())
                                        }.padding(.trailing, 5)
                                }
                            }.padding(10)
                                .background(.lightPeach)
                                .frame(width: UIScreen.main.bounds.width - 20)
                                .cornerRadius(20)
                        }
                    }
                }
                    
            }
        }.onAppear {
            for user in userViewModel.friends {
                print(user.displayName)
                var books: [Book] = []
                Book.loadBooksFromFirestore(user: user) { fetchedBooks in
                    DispatchQueue.main.async {
                        books = fetchedBooks // Update the published books
                        if let matchBook = books.first(where: { $0.id == book.id }), let readStatus = matchBook.readStatus, let ownerStatus = matchBook.bookshelf {
                            let array = [ownerStatus, readStatus]
                            userStatuses[user.id] = array

                        } else {
                            userStatuses[user.id] = ["Not Owned", "--"]
                        }
                    }
                }
                }
            bookshelfViewModel.getCurrentUserStatus()

            }
                    
        }
    }


//#Preview {
//    BookDetail()
//}
