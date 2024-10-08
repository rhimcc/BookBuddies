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
    @State var bookInfo: Bool = false
    @State var currentBook: Book?
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var bookColor: Color = .gray
    @State private var currentIndex: Int = 0
    @State private var currentBookshelfIndex: Int = 0
    @State var bookshelfOwner: User

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
               
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
                            Image(systemName: "lessthan")
                        }
                        Text(bookshelfViewModel.currentBookshelf)
                        Button {
                            if (currentBookshelfIndex == 2) {
                                currentBookshelfIndex = 0
                            } else {
                                currentBookshelfIndex += 1
                            }
                            bookshelfViewModel.currentBookshelf = bookshelfViewModel.bookshelfOptions[currentBookshelfIndex]
                            
                        } label : {
                            Image(systemName: "greaterthan")
                            
                        }
                    }
                }
                ZStack { // adding books
                    BookshelfBackground()
                        .position(x: UIScreen.main.bounds.width/2, y: (UIScreen.main.bounds.height - 50) / 2)
                    ForEach(Array(bookshelfViewModel.shelfOptions.enumerated()), id: \.element) { index, option in
                        let bookArray = books.filter {$0.readStatus == option && $0.bookshelf == bookshelfViewModel.bookshelfOptions[currentBookshelfIndex]}
                        HStack (spacing: 0) {
                            ForEach(Array(bookArray.enumerated()), id: \.element.id) { index2, book in
                                Button {
                                    bookshelfViewModel.bookPreview.toggle()
                                    currentBook = book
                                    currentIndex = index2
                                    bookshelfViewModel.currentBookPreview = book
                                } label : {
                                    BookSpineView(book: book, bookshelfViewModel: bookshelfViewModel)
                                        .frame(width: 20, height: 100) // Adjust width and height according to your design
                                        .rotationEffect(Angle(degrees: -90))
                                        .padding(.trailing, 4)
                                        .shadow(color: .black.opacity(0.2), radius: 5)

                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 60, height: 120, alignment: .leading)
                        .position(x: UIScreen.main.bounds.width/2 + 10, y: getY(option: option))
                        
                    }

                    if bookshelfViewModel.bookPreview {
                        Button {
                            bookshelfViewModel.bookPreview.toggle()
                        } label : {
                            Color.black.opacity(0.6)
                                .edgesIgnoringSafeArea(.all)
                        }
                        
                        HStack {
                            Button {
                                currentIndex -= 1
                                if (currentIndex < 0) {
                                    currentIndex = books.count - 1
                                }
                                bookshelfViewModel.currentBookPreview = books[currentIndex]
                            } label : {
                                Image(systemName: "lessthan.square.fill")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 30))
                            }
                            BookPreview(bookshelfViewModel: bookshelfViewModel)
                            Button {
                                currentIndex += 1
                                if (currentIndex >= books.count) {
                                    currentIndex = 0
                                }
                                bookshelfViewModel.currentBookPreview = books[currentIndex]
                                
                            } label : {
                                Image(systemName: "greaterthan.square.fill")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 30))
                                
                            }
                            
                        }
                    }
                }.onAppear {
                    bookshelfViewModel.inSearch = false
                    
                }
                Spacer()
            }.onAppear {
               loadBooks()
            }
        }
    }
    
    func getY(option: String) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height - 50
        let middleY = screenHeight / 2
        switch option {
        case "Reading":
            return middleY - 150 - 100
        case "Unread":
            return middleY - 100
        case "Read":
            return middleY + 150 - 100
        default:
            return 500
        }
    }
    
    func loadBooks() {
        Book.loadBooksFromFirestore(user: bookshelfOwner) { fetchedBooks in
              DispatchQueue.main.async {
                  self.books = fetchedBooks // Update the published books
              }
          }
      }
    
}

