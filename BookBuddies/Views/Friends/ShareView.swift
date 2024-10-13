//
//  ShareView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 11/10/2024.
//

import SwiftUI
// ShareView
struct ShareView: View {
    var book: Book
    var userStatuses: [String: [String]]
    var userViewModel: UserViewModel
    @State var searchQuery: String = ""
    var chatViewModel: ChatViewModel


    var body: some View {
        NavigationStack {
            VStack {
                BookView(book: book, inSearch: false)
                    .frame(width: 150, height: 210)
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                HStack {
                    Text("Send")
                    Text(book.title ?? "")
                        .lineLimit(1)
                        .bold()
                    Text("to:")
                }
                TextField("Friend...", text: $searchQuery)
                    .textFieldStyle(.roundedBorder)
                ScrollView {
                    if searchQuery.isEmpty {
                        ForEach(userViewModel.friends) { friend in
                            ShareToFriendView(friend: friend, userStatuses: userStatuses, userViewModel: userViewModel, book: book)
                        }
                    } else {
                        ForEach(userViewModel.friends.filter {$0.displayName.contains(searchQuery)}) { friend in
                            ShareToFriendView(friend: friend, userStatuses: userStatuses, userViewModel: userViewModel, book: book)
                        }
                    }
                }
            }.padding(10)
        }
    }
}
//
//#Preview {
//    ShareView()
//}
