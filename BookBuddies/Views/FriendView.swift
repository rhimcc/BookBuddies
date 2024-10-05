//
//  FriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 5/10/2024.
//

import SwiftUI

struct FriendView: View {
    @State var users: [User] = []
    var body: some View {
        VStack {
            ForEach(users) { user in
                Text(user.displayName)
            }
        }.onAppear {
           loadUsers()
        }
    }
    func loadUsers() {
        UserViewModel.loadUsers() { users in
              DispatchQueue.main.async {
                  self.users = users
              }
          }
      }
}

//#Preview {
//    FriendView()
//}
