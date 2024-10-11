//
//  BookView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookView: View {
//    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    var book: Book
    @State var inSearch: Bool
    var image: String = ""
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 5, y: 0)
    
            AsyncImage(url: URL(string: getImage())) { image in
                image.resizable()
                    .scaledToFill()
                    .clipped()
            } placeholder: {
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
            )
        }
    }
    
    func getImage() -> String {
        if (inSearch) {
            return book.convertURL(imageURL: book.volumeInfo?.imageLinks?.thumbnail ?? "") ?? ""
        } else {
            return book.convertURL(imageURL: book.image ?? "") ?? ""
        }
    }
}

//#Preview {
//    BookView(image: "https://books.google.com/books/content?id=rgbRAgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
//}
