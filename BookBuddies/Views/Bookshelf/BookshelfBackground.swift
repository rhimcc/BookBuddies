//
//  Bookshelf.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookshelfBackground: View {
    var body: some View {
        ZStack {
            Rectangle() // top of the bookshelf
                .fill(.lightPeach)
                .frame(width: UIScreen.main.bounds.width - 40, height: 20)
                .padding(0)
                .offset(y: -220)
            VStack (spacing: 0) {
                ForEach(0..<3) { i in
                    ShelfView(totalWidth: UIScreen.main.bounds.width - 60, totalHeight: 120, text: getText(i: i))
                }
            }
        }.offset(y: -100)
    }
    
    func getText(i: Int) -> String{
        switch(i) {
        case 0:
            return "Reading"
        case 1:
            return "Unread"
        case 2:
            return "Read"
        default:
            return ""
        }
    }
    
}


#Preview {
    BookshelfBackground()
}
