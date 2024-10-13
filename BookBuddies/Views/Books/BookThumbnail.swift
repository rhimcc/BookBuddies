//
//  BookThumbnail.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 13/10/2024.
//

import SwiftUI

struct BookThumbnail: View {
    var book: Book
    var body: some View {
        VStack {
            BookView(book: book, inSearch: false)
                .frame(width: 70, height: 100)
                .padding()
            if let title = book.title, let authors = book.authors {
                Text(title)
                    .bold()
                Text(authors)
                
            }
        }.frame(width: 150, height: 200)

        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.veryLightPeach)
                .shadow(color: .black, radius: 5)
        }
        
    }
}

//#Preview {
//    BookThumbnail()
//}
