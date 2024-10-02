//
//  Bookshelf.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import SwiftUI

struct BookshelfBackground: View {
    var body: some View {
        VStack {
            Text("Your books")
            VStack (spacing: 0) {
                ForEach(0..<5) { i in
                    ZStack {
                        Rectangle()
                            .fill(.darkPeach)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 140)
                        ShelfView(totalWidth: UIScreen.main.bounds.width - 60, totalHeight: 120)
                    }
                    .padding(0)
                }
            }
        }
    }
}


#Preview {
    BookshelfBackground()
}
