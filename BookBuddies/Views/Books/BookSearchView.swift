//
//  BookSearchView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 10/10/2024.
//

import SwiftUI

struct BookSearchView: View {
    @State var bookshelf: Bookshelves = .yourBooks
    @ObservedObject var searchViewModel: BookSearchViewModel = BookSearchViewModel()
    @ObservedObject var chatViewModel: ChatViewModel
    @State var placeHolderBooks: [Book] = []
    var currentUser: User
    var friend: User
    var body: some View {
        VStack {
            
            Picker("Bookshelf", selection: $bookshelf) {
                ForEach(Bookshelves.allCases, id: \.self) { bookshelf in
                    Text(bookshelf.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            .padding(10)
            .padding(.top, 20)
            TextField("prompt", text: $searchViewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding(10)
            ScrollView {
                if (bookshelf == .yourBooks) {
                    ForEach(chatViewModel.currentUserBooks.filter {$0.title?.contains(searchViewModel.searchQuery) ?? false}) { book in
                        BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "currentUser")
                    }
                } else if (bookshelf == .theirBooks) {
                    ForEach(chatViewModel.otherUserBooks.filter {$0.title?.contains(searchViewModel.searchQuery) ?? false}) { book in
                        BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "otherUser")
                    }
                } else {
                    ForEach(searchViewModel.books) { book in
                        BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "google")
                    }
                }
                if (searchViewModel.searchQuery.isEmpty) {
                    if (bookshelf == .yourBooks) {
                        ForEach(chatViewModel.currentUserBooks) { book in
                            BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "currentUser")
                        }
                    } else if (bookshelf == .theirBooks) {
                        ForEach(chatViewModel.otherUserBooks) { book in
                            BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "currentUser")
                        }
                    } else if (bookshelf == .allBooks) {
                        Text("Search for books!")
                    }
                }

            }
        }.presentationDragIndicator(.visible)

        .onAppear {
            print(chatViewModel.currentUserBooks.count)
            print(chatViewModel.otherUserBooks.count)
        }
    }
    
    enum Bookshelves: String, CaseIterable, Identifiable {
        case yourBooks =  "Your books"
        case theirBooks = "Their books"
        case allBooks = "All books"
        var id: String { self.rawValue }
    }
    
  

    
}
//
//#Preview {
//    BookSearchView(userViewModel: <#UserViewModel#>, chatViewModel: <#ChatViewModel#>, friend: <#User#>)
//}
