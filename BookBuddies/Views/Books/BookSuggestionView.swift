//
//  BookSuggestionView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 13/10/2024.
//

import SwiftUI

struct BookSuggestionView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        Text("What your friends are reading")
            .font(.system(size: 20))
            .bold()
            .padding()
        ScrollView {
            ForEach(userViewModel.friends, id: \.id) { friend in
                VStack(alignment: .leading) {
                    Text(friend.displayName)
                        .font(.headline)
                        .padding(.horizontal)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let bookArray = userViewModel.friendsReading[friend.id], !bookArray.isEmpty {
                                ForEach(bookArray, id: \.id) { book in
                                    NavigationLink {
                                        BookDetail(book: book, bookshelfViewModel: BookshelfViewModel(), userViewModel: userViewModel, source: "other")
                                     
                                    } label : {
                                        BookThumbnail(book: book)
                                            .frame(width: 150, height: 200)

                                    }
                                }
                            } else {
                                Text("\(friend.displayName) is not reading anything")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 5)
                            }
                        }
                        .padding()
                    }.frame(maxWidth: UIScreen.main.bounds.width - 20)
                }
                .padding(.bottom)
            }
        }
        .padding()
    }
}


//#Preview {
//    BookSuggestionView()
//}
