//
//  BookPreview.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookPreview: View {
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
//    @State var book: Book
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
                    if let book = bookshelfViewModel.currentBookPreview, let readStatus = book.readStatus, let bookshelf = book.bookshelf {
                        Text(readStatus)
                        Text(bookshelf)
                    }
                    Spacer()
                   

                }
            }.frame(width: 280, height: 160)
        
    }
}
