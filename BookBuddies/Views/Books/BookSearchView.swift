//
//  BookSearchView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 10/10/2024.
//

import SwiftUI

struct BookSearchView: View {
    @State var bookshelf: Bookshelves = .yourBooks
    @ObservedObject var searchViewModel: BookViewModel = BookViewModel()
    @ObservedObject var chatViewModel: ChatViewModel
    var currentUser: User
    var friend: User
    var body: some View {
        VStack {
            Picker("Bookshelf", selection: $bookshelf) {
                ForEach(Bookshelves.allCases, id: \.self) { bookshelf in
                    Text(bookshelf.rawValue.capitalized)
                }
            }.pickerStyle(.segmented)
            TextField("prompt", text: $searchViewModel.searchQuery)
                .textFieldStyle(.roundedBorder)
            Text(searchViewModel.searchQuery)
            
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
            }
        }
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
