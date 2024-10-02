//
//  BookView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookView: View {
    var book: Book
    @State var image: String = ""
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 75, height: 105)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 5, y: 0)
            
    
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 105)
                    .clipped()
            } placeholder: {
                Text("not loaded")
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
        }.onAppear {
            image = book.convertURL()
        }
    }
}

//#Preview {
//    BookView(image: "https://books.google.com/books/content?id=rgbRAgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
//}
