//
//  BookDetail.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookDetail: View {
    var book: Book
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var selectedReadStatus: String = ""
    @State private var selectedBookshelf: String = ""
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
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                        .padding(.vertical, 5)
                    if let book = bookshelfViewModel.currentBookPreview {
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
                    }
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 1)
                        .padding(.vertical, 5)
                }
                .padding(.top, 20)
                    .onAppear {
                        bookshelfViewModel.bookPreview.toggle()
                        if let book = bookshelfViewModel.currentBookPreview, let bookshelf = book.bookshelf, let shelf = book.readStatus {
                            selectedBookshelf = bookshelf
                            selectedReadStatus = shelf
                        }
                        
                    }
                
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
                
            }
        }
    }
}

//#Preview {
//    BookDetail()
//}
