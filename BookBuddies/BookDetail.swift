//
//  BookDetail.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookDetail: View {
    var book: Book
    var bookshelfViewModel: BookshelfViewModel
    var body: some View {
        VStack {
            if let title = book.title {
                Text(title)
            }
        }
    }
}

//#Preview {
//    BookDetail()
//}
