//
//  SearchResultsView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: BookSearchViewModel
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State var books: [Book] = []
    @State private var isLoading: Bool = true // New state variable to track loading status

    
    var body: some View {
        ZStack {
            ScrollView {
                if isLoading { // shows progress, so the user knows it is loading
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ForEach(viewModel.books.filter { !books.contains($0)}) { book in //shows each book in the search result
                            BookRow(bookshelfViewModel: bookshelfViewModel, book: book)
                        }
                    }
            }.onAppear {
                bookshelfViewModel.inSearch.toggle()
                loadBooks() // loads books
            }
            if bookshelfViewModel.bookSave {
                Button {
                    bookshelfViewModel.bookSave.toggle() // toggles if book is being saved to bookshelf
                } label : {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                }
                if let currentBook = bookshelfViewModel.currentBookSave { // if there is a book in the book save variable, ie. a book is being saved
                    SaveBookView(bookshelfViewModel: bookshelfViewModel, userViewModel: userViewModel, book: currentBook)
                }
            
            }
            
           
        }
       
    }
    
    func loadBooks() { // loads books
        userViewModel.loadBooksFromFirestore(user: userViewModel.currentUser) { fetchedBooks in
            DispatchQueue.main.async {
                self.books = fetchedBooks
                self.isLoading = false // Set loading to false after fetching is done

            }
        }
    }
}



//#Preview {
//    SearchResultsView()
//}
