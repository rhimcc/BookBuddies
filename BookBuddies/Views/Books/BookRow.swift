//
//  BookRow.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookRow: View { // Called from the search bar
    var bookshelfViewModel: BookshelfViewModel
    var book: Book
    var body: some View {
        ZStack {
            HStack {
                let authors = book.getAuthorStringFromJSON()
                BookView(book: book, inSearch: bookshelfViewModel.inSearch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75)
                    .padding(5)
                Spacer()
                VStack(alignment: .leading) {
                    if let volumeInfo = book.volumeInfo {
                        Text(volumeInfo.title) // book name
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(alignment: .leading)
                            .bold()
                            .font(.system(size: 20))
                    }
                    
                    Text(authors) // book authors
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    bookshelfViewModel.bookSave.toggle() // toggles bool for book save popup
                    bookshelfViewModel.currentBookSave = book // sets the book which is shown in save as the book

                } label : {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.white, .navy)
                        .font(.system(size: 30))
                        .padding(10)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 20, height: 120)
            .background(.peach)
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.33), radius: 1, x: 2, y: 2)
            .padding(.vertical, 2)
        }
    }
}

//#Preview {
//    BookRow(bookshelfViewModel: BookshelfViewModel(), book: Book(id: "123", title: "grhiwojk", authors: "hwuij", bookshelf: "hgewj", image: "fwheuj", readStatus: "fewj", desc: "fweik", pageCount: 12, category: "grwe", userPage: 23))
//}
