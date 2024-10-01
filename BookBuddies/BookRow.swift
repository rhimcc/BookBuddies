//
//  BookRow.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookRow: View {
    var book: Book
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                let imageURL = book.convertURL()
                let authors = book.getAuthorString()
                BookView(image: imageURL, width: 75, height: 105)
                   
                
                VStack(alignment: .leading) {
                    Text(book.volumeInfo?.title ?? "") // book name
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 150, alignment: .leading)
                        .bold()
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                    
                    Text(authors)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
            
                    
                }
                Button ("Add to"){
                    print(book.volumeInfo?.imageLinks?.thumbnail ?? "")
                }
            }
            .frame(height: 120)
            .background(.peach)
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.33), radius: 1, x: 2, y: 2)
            .padding(.vertical, 2)
        }
    }
}

//#Preview {
//    BookRow()
//}
