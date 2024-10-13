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
                VStack {
                    HStack {
                        Text(friend.displayName)
                            .font(.headline)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let bookArray = userViewModel.friendsReading[friend.id], !bookArray.isEmpty {
                                ForEach(bookArray, id: \.id) { book in
                                    NavigationLink {
                                        BookDetail(book: book, bookshelfViewModel: BookshelfViewModel(), userViewModel: userViewModel, source: "other")
                                        
                                    } label : {
                                        BookThumbnail(book: book)
                                            .frame(width: 150, height: 200)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 5)

                                        
                                    }
                                }
                            } else {
                                Text("\(friend.displayName) is not reading anything")
                                    .foregroundColor(.gray)
                            }
                        }
                    }.frame(maxWidth: UIScreen.main.bounds.width - 20)
                }.frame(alignment: .leading)
            }
        }
        .padding()
    }
}


//#Preview {
//    BookSuggestionView()
//}
