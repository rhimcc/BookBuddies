//
//  FriendRow.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import SwiftUI

struct FriendRow: View {
    @State var friend: User
    @ObservedObject var userViewModel : UserViewModel
    @State var existingFriend: Bool = false
    var body: some View {
        HStack {
            VStack {
                Text(friend.displayName)
                Text(friend.id)
            }
            if (existingFriend) {
                Text("Added")
            } else {
                Button ("Add") {
                    userViewModel.addFriendToFirestore(user: friend)
                }
            }
        }.onAppear {
            isFriend()
        }
    }
    func isFriend() {
        userViewModel.isFriend(user: friend) { isFriend in
            if isFriend {
                existingFriend = true
            } else {
                existingFriend = false
            }
        }
    }
}

//#Preview {
//    FriendRow()
//}
