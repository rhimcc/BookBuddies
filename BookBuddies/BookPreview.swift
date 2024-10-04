//
//  BookPreview.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookPreview: View {
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    var readImageName: String {
        switch (bookshelfViewModel.currentBookPreview?.readStatus) {
        case "Unread":
            return "book.closed"
        case "Read":
            return "book.closed.fill"
        case "Reading":
            return "book"
        default:
            return ""
        }
    }
    
    var bookshelfImageName: String {
        switch (bookshelfViewModel.currentBookPreview?.bookshelf) {
        case "Owned":
            return "house"
        case "Library":
            return "building.columns"
        case "Borrowed":
            return "person.2"
        default:
            return ""
        }
    }
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                VStack {
                    HStack {
                        Button {
                            bookshelfViewModel.bookPreview.toggle()
                        } label: {
                            Image(systemName: "xmark")
                        }.foregroundColor(.gray)
                            .font(.system(size: 20))
                            .padding(15)
                        Spacer()
                    }
                    Spacer()
                    HStack {

                        if let book = bookshelfViewModel.currentBookPreview {
                            BookView(bookshelfViewModel: bookshelfViewModel, book: book)
                                .frame(width: 75, height: 105)

                                .padding(.horizontal, 10)
                            
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
                            }
                        }

                        if let book = bookshelfViewModel.currentBookPreview {
                            
                        Spacer()

                        NavigationLink {
                            BookDetail(book: book, bookshelfViewModel: bookshelfViewModel)
                        } label : {
                            Image(systemName: "greaterthan")
                                .foregroundStyle(.gray)
                        }
                            Spacer()
                    }
                    }
                    HStack {
                        Image(systemName: bookshelfImageName)
                        Text(bookshelfViewModel.currentBookPreview?.bookshelf ?? "")
                            .onAppear {
                                print(bookshelfViewModel.currentBookPreview?.bookshelf)
                            }
                    Spacer()
                        Image(systemName: readImageName)
                        Text(bookshelfViewModel.currentBookPreview?.readStatus ?? "")
                            .onAppear {
                                print(bookshelfViewModel.currentBookPreview?.readStatus)
                            }
                    }.padding(10)
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Spacer()
                   

                }
            }.frame(width: 280, height: 160)
        
    }
}
