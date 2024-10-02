//
//  Bookshelf.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI
import SwiftData

struct Bookshelf: View {
    @Query var books: [Book]
    @State var bookInfo: Bool = false
    @State var currentBook: Book?
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var bookColor: Color = .gray
    @State private var currentIndex: Int = 0
    @State private var bookColors: [String: Color] = [:] // Dictionary to hold colors for each book


    var body: some View {
        NavigationStack {
            ZStack {
                BookshelfBackground()
                HStack {
                    ForEach(Array(books.enumerated()), id: \.element.id) { index, book in
                        Button {
                            bookshelfViewModel.bookPreview.toggle()
                            currentBook = book
                            currentIndex = index
                            bookshelfViewModel.currentBookPreview = book
                        } label : {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(bookColors[book.id ?? ""] ?? .gray)
                                        .frame(width: 20, height: 100)
                                        .shadow(color: .black.opacity(0.5), radius: 2)
                                        .onAppear {
                                            book.getImageColour { color in
                                                DispatchQueue.main.async {
                                                    bookColors[book.id ?? ""] = color
                                                }
                                            }
                                        }
                                    
                                    Text(book.title ?? "")
                                        .rotationEffect(Angle(degrees: -90))
                                        .bold()
                                        .foregroundStyle(.black)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .frame(width: 100, height: 100)
                                }.position(x: CGFloat(10 * index) + 55, y: 100)

                        }.padding(.horizontal, 0)
                    }
                    
                    
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
            
        }
    }
}
//
//#Preview {
//    Bookshelf()
//}
