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
            
            // lets the user change where they want to get books from to send to others
            Picker("Bookshelf", selection: $bookshelf) {
                ForEach(Bookshelves.allCases, id: \.self) { bookshelf in
                    Text(bookshelf.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            .padding(10)
            .padding(.top, 20)
            
            
            TextField("Search books...", text: $searchViewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding(10)
            
            ScrollView {
                if (bookshelf == .yourBooks) {
                    ForEach(chatViewModel.currentUserBooks.filter  {$0.title?.contains(searchViewModel.searchQuery) ?? false}) { book in // gets books for the current user
                        BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "currentUser")
                    }
                } else if (bookshelf == .theirBooks) { // gets books for the other user
                    ForEach(chatViewModel.otherUserBooks.filter {$0.title?.contains(searchViewModel.searchQuery) ?? false}) { book in
                        BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "otherUser")
                    }
                } else {
                    ForEach(searchViewModel.books) { book in // gets books from the search
                        BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "google")
                    }
                }
                if (searchViewModel.searchQuery.isEmpty) { // if there hasnt been anything searched
                    if (bookshelf == .yourBooks) { // show general list of the current users books
                        ForEach(chatViewModel.currentUserBooks) { book in
                            BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "currentUser")
                        }
                    } else if (bookshelf == .theirBooks) { // show list of other users books
                        ForEach(chatViewModel.otherUserBooks) { book in
                            BookForChatRow(bookshelfViewModel: BookshelfViewModel(), chatViewModel: chatViewModel, book: book, source: "currentUser")
                        }
                    }
                }

            }
        }.presentationDragIndicator(.visible)
    }
    
    enum Bookshelves: String, CaseIterable, Identifiable { // specifies states for bookshelves
        case yourBooks =  "Your books"
        case theirBooks = "Their books"
        case allBooks = "All books"
        var id: String { self.rawValue }
    }
    
  

    
}
