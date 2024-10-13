//
//  ErrorView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 13/10/2024.
//

import SwiftUI

struct ErrorView: View {
    var errorMessage: String
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill") // warning icon
                .foregroundStyle(.darkRed)
                .font(.system(size: 25))
            Text(errorMessage)
        }.padding()
        .background {
            
            RoundedRectangle(cornerRadius: 20) // background
                .fill(.red.opacity(0.5))
                .stroke(.darkRed, lineWidth: 3)
        }
    }
}

#Preview {
    ErrorView(errorMessage: "rip")
}
