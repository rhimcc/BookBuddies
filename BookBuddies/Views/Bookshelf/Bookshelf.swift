//
//  Bookshelf.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI
import SwiftData

struct Bookshelf: View {
    @State var books: [Book] = []
    @State var currentUserBooks: [Book] = []
    @State var bookInfo: Bool = false
    @State var currentBook: Book?
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var bookColor: Color = .gray
    @State private var currentIndex: Int = 0
    @State private var currentBookshelfIndex: Int = 0
    @State var bookshelfOwner: User
    @State var bookshelfText: String = ""
    var userViewModel: UserViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text(bookshelfText) // shows the current bookshelf
                    .font(.title)
                    .bold()

                if (bookshelfOwner.id == User.getCurrentUser()) {
                    HStack { // Changing the bookshelf
                        Button {
                            if (currentBookshelfIndex == 0) {
                                currentBookshelfIndex = 2
                            } else {
                                currentBookshelfIndex -= 1
                            }
                            bookshelfViewModel.currentBookshelf = bookshelfViewModel.bookshelfOptions[currentBookshelfIndex]
                            
                        } label : {
                            Image(systemName: "arrowtriangle.backward.circle.fill")
                                .font(.system(size: 30))
                                .bold()
                        }
                        Spacer()
                        Text(bookshelfViewModel.currentBookshelf)
                            .font(.system(size: 25))
                        Spacer()

                        Button {
                            if (currentBookshelfIndex == 2) {
                                currentBookshelfIndex = 0
                            } else {
                                currentBookshelfIndex += 1
                            }
                            bookshelfViewModel.currentBookshelf = bookshelfViewModel.bookshelfOptions[currentBookshelfIndex]
                            
                        } label : {
                            Image(systemName: "arrowtriangle.right.circle.fill")
                                .font(.system(size: 30))
                                .bold()
                        }
                    }
                    .padding(.vertical, 5)
                    .frame(width: 200)
                }

                ZStack { // Adding books
                    BookshelfBackground() // background
                        .position(x: UIScreen.main.bounds.width / 2, y: (UIScreen.main.bounds.height - 100) / 2) // centers

                    VStack (spacing: 30){ // Stack to hold all the shelves
                        ForEach(Array(bookshelfViewModel.shelfOptions.enumerated()), id: \.element) { index, option in
                            let bookArray = books.filter { $0.readStatus == option && $0.bookshelf == bookshelfViewModel.bookshelfOptions[currentBookshelfIndex] }

                            // Individual ScrollView for each shelf
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack(spacing: 2) {
                                    ForEach(Array(bookArray.enumerated()), id: \.element.id) { index2, book in
                                        Button { // previews the book when the user clicks on it
                                            bookshelfViewModel.bookPreview.toggle()
                                            currentBook = book
                                            currentIndex = index2
                                            bookshelfViewModel.currentBookPreview = book
                                            bookshelfViewModel.getCurrentUserStatus()
                                        } label: {
                                            BookSpineView(book: book, bookshelfViewModel: bookshelfViewModel) // shows as a book spine
                                                .frame(width: 20, height: 100)
                                                .rotationEffect(Angle(degrees: -90))
                                                .padding(.trailing, 4)
                                                .shadow(color: .black.opacity(0.2), radius: 5)
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 80, height: 120, alignment: .center)
                        }
                    }.frame(alignment: .center)

                    if bookshelfViewModel.bookPreview { // shows the preview of the book
                        Button {
                            bookshelfViewModel.bookPreview.toggle() // closes the preview if user clicks elsewhere
                        } label : {
                            Color.black.opacity(0.6)
                                .edgesIgnoringSafeArea(.all)
                        }
                        
                        HStack { // changing the previewed book
                            Button { // previous button
                                currentIndex -= 1
                                if (currentIndex < 0) {
                                    currentIndex = books.count - 1
                                }
                                bookshelfViewModel.currentBookPreview = books[currentIndex]
                                bookshelfViewModel.getCurrentUserStatus()

                            } label : {
                                Image(systemName: "lessthan.square.fill")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 30))
                            }
                            // book preview
                            BookPreview(bookshelfViewModel: bookshelfViewModel, currentUser: userViewModel.currentUser, currentUserBooks: currentUserBooks, userViewModel: userViewModel, source: bookshelfOwner.id == userViewModel.currentUser.id ? "self" : "other", bookshelfOwner: bookshelfOwner)
                            
                            // next button
                            Button {
                                currentIndex += 1
                                if (currentIndex >= books.count) {
                                    currentIndex = 0
                                }
                                bookshelfViewModel.currentBookPreview = books[currentIndex]
                                bookshelfViewModel.getCurrentUserStatus()
                                
                            } label : {
                                Image(systemName: "greaterthan.square.fill")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 30))
                            }
                            
                        }
                    }
                }.onAppear { // ZStack
                    bookshelfViewModel.inSearch = false
                }
                Spacer()
            }
            .onAppear {
                loadBooks()
                loadCurrentUserBooks()
                if (bookshelfOwner.id == User.getCurrentUser()) { // sets the text for the owner of the bookshelf
                    bookshelfText = "Your Bookshelf"
                } else {
                    bookshelfText = bookshelfOwner.displayName + "'s Bookshelf"
                }
            }
        }
    }
    
    func loadBooks() { // loads the books of the owner of the bookshelf
        userViewModel.loadBooksFromFirestore(user: bookshelfOwner) { fetchedBooks in
            DispatchQueue.main.async {
                self.books = fetchedBooks
            }
        }
    }
    
    func loadCurrentUserBooks() { // loads the books of the current user
        userViewModel.loadBooksFromFirestore(user: userViewModel.currentUser) { fetchedBooks in
            DispatchQueue.main.async {
                bookshelfViewModel.currentUserBooks = fetchedBooks
            }
        }
    }
}

