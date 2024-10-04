//
//  ShelfView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct ShelfView: View {
    var totalWidth: CGFloat
    var totalHeight: CGFloat
    var text: String
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.darkPeach)
                .frame(width: totalWidth + 20, height: totalHeight + 30, alignment: .center)
                .offset(y: 15)
            Rectangle() // whole shelf
                .fill(.peach)
                .frame(width: totalWidth, height: totalHeight)
            
            Rectangle() // back of shelf
                .fill(.darkPeach)
                .frame(width: totalWidth - 30, height: totalHeight - 20)
                .offset(y: -10)
                .shadow(color: .black.opacity(0.2), radius: 10)
            
            Rectangle() // lines for corners
                .fill(.darkPeach)
                .frame(width: 2, height: 30)
                .rotationEffect(Angle(degrees: 36))
                .offset(x: -totalWidth/2 + 10, y: 50)
                .shadow(color: .black.opacity(0.2), radius: 10)
            Rectangle()
                .fill(.darkPeach)
                .frame(width: 2, height: 30)
                .rotationEffect(Angle(degrees: 360 - 36))
                .offset(x: totalWidth/2 - 10, y: 50)
                .shadow(color: .black.opacity(0.2), radius: 10)
            Text(text)
                .offset(y: 75)
            
        }.frame(width: totalWidth + 20, height: totalHeight + 30)
    }
}

#Preview {
    ShelfView(totalWidth: UIScreen.main.bounds.width - 60, totalHeight: 120, text: "String")
}
