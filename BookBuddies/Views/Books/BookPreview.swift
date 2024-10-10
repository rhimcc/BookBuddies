//
//  BookPreview.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookPreview: View {
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    
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
                            BookView(book: book, inSearch: false)
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
                    }
                    HStack {
                        VStack (alignment: .center){
                            Image(systemName: bookshelfViewModel.getBookshelfImage())
                            Image(systemName: bookshelfViewModel.getReadImage())
                        }
                        VStack(alignment: .leading) {
                            Text(bookshelfViewModel.currentBookPreview?.bookshelf ?? "")
                            Text(bookshelfViewModel.currentBookPreview?.readStatus ?? "")
                        }
                     
                       
                        Spacer()
                        NavigationLink {
                            if let book = bookshelfViewModel.currentBookPreview {
                                BookDetail(book: book, bookshelfViewModel: bookshelfViewModel)
                            }
                        } label : {
                            HStack {
                                Text("View More")
                                Image(systemName: "greaterthan")
                            }.foregroundStyle(.navy)

                        }
                    }.padding(10)
                        .font(.system(size: 15))
                        .foregroundStyle(.navy)
                    Spacer()
                }
            }.frame(width: 280, height: 160)
        
    }
}
