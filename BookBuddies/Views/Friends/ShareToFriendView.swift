//
//  ShareToFriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 11/10/2024.
//

import SwiftUI
struct ShareToFriendView: View {
    var friend: User
    var userStatuses: [String: [String]]
    var userViewModel: UserViewModel
    var book: Book
    
    var body: some View {
        HStack {
            Text(friend.displayName) // name
            Spacer()
            if let array = userStatuses[friend.id] { // gets the array from the user's status
                HStack {
                    VStack {
                        Text(array[0])
                        Text(array[1])
                    }
                    VStack {
                        Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: array[0]))
                        Image(systemName: BookshelfViewModel.getReadImage(readStatus: array[1]))
                    }
                }.frame(alignment: .trailing)
            }
            NavigationLink {
                let chatViewModel: ChatViewModel = ChatViewModel()
                ChatView(userViewModel: userViewModel, friend: friend, chatViewModel: chatViewModel) // puts user in the chat view
                    .onAppear {
                        chatViewModel.book = book
                        
                    }
            } label : {
                ZStack {
                    Rectangle()
                        .fill(.navy)
                        .frame(width: 40, height: 40)
                        .cornerRadius(5)
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.lightPeach)
                .frame(width: UIScreen.main.bounds.width - 20)
        )
    }
}
