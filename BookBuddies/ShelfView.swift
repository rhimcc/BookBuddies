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
    var body: some View {
        ZStack {

            Rectangle() // whole shelf
                .fill(.peach)
                .position(x: totalWidth/2, y: totalHeight/2)
            
            Rectangle() // back of shelf
                .fill(.darkPeach)
                .frame(width: totalWidth - 30, height: totalHeight - 20)
                .position(x: totalWidth/2, y: totalHeight/2 - 10)
                .shadow(color: .black.opacity(0.2), radius: 10)
            
            Rectangle() // lines for corners
                .fill(.darkPeach)
                .frame(width: 2, height: 30)
                .rotationEffect(Angle(degrees: 36))
                .position(x: 10, y: totalHeight - 12)
                .shadow(color: .black.opacity(0.2), radius: 10)
            Rectangle()
                .fill(.darkPeach)
                .frame(width: 2, height: 30)
                .rotationEffect(Angle(degrees: 360 - 36))
                .position(x: totalWidth - 10, y: totalHeight - 12)
                .shadow(color: .black.opacity(0.2), radius: 10)
            
        }.frame(width: totalWidth, height: totalHeight)
        
    }
}
//
//#Preview {
//    ShelfView()
//}
