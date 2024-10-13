//
//  BookSpineView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 3/10/2024.
//

import SwiftUI

struct BookSpineView: View {
    var book: Book
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State var fontColour: Color = .black
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(bookshelfViewModel.bookColors[book.id ?? ""] ?? .gray) // fills with the stored colour, identified by the book id
                .onAppear {
                    book.getImageColour { color in // loads the colour
                        DispatchQueue.main.async {
                            bookshelfViewModel.bookColors[book.id ?? ""] = color
                        }
                    }
                }
            
            Text(book.title ?? "") // shows title
                .bold()
                .foregroundStyle(getFontShade())
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 5)
        }.frame(width: 100, height: 20)
    }
    
    func getFontShade() -> Color { // returns black or white depending on if the background colour is light or dark
        if let colour = bookshelfViewModel.bookColors[book.id ?? ""] {
            let UIColour = UIColor(colour)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            UIColour.getRed(&red, green: &green, blue: &blue, alpha: nil)
            if (red + blue + green)/3 > 0.5 {
                return .black
            } else {
                return .white
            }
            
        }
        return .black
    }
    
    
}

//#Preview {
//    BookSpineView()
//}
