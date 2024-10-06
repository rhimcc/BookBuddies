//
//  FriendSearchResultsView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import SwiftUI

struct FriendSearchResultsView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State var users: [User] = []
    var body: some View {
        ScrollView {
            ForEach(users.filter {$0.displayName.lowercased().contains(searchViewModel.searchQuery.lowercased()) && $0.id != User.getCurrentUser()}) { user in
                FriendRow(friend: user, userViewModel: userViewModel, friendsList: false)
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
