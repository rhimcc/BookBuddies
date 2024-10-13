//
//  FriendSearchResultsView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import SwiftUI

struct FriendSearchResultsView: View {
    @StateObject var searchViewModel: SearchViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State var users: [User] = []
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(userViewModel.allUsers.filter {$0.displayName.lowercased().contains(searchViewModel.searchQuery.lowercased()) && $0.id != User.getCurrentUser()}) { user in
                    FriendRow(friend: user, userViewModel: userViewModel, friendsList: false) // shows each friend
                }
            }
        }
    }
}
