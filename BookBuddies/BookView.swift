//
//  BookView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookView: View {
    var image: String
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: width, height: height)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 5, y: 0)
            
    
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
            } placeholder: {
                Text("not loaded")
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 5)
                )
                
    
           
        }
    }
}

//#Preview {
//    BookView(image: "https://books.google.com/books/content?id=rgbRAgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
//}
