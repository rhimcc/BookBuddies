//
//  BookPreview.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookPreview: View {
    var book: Book
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                
                    HStack {
                        BookView(book: book)
                        VStack {
                            Text(book.volumeInfo?.title ?? "")
                            Text(book.getAuthorString())
                        }
                        
                    }
            }.frame(width: 250, height: 150)
        }
    }
}
