//
//  AddFriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import SwiftUI

struct AddFriendView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var searchViewModel: SearchViewModel = SearchViewModel()
    var body: some View {
        VStack {
            Text("Add Friends")
                .font(.title)
                .bold()
            TextField("Search by name", text: $searchViewModel.searchQuery)
                .padding(.horizontal, 10)
                .textFieldStyle(.roundedBorder)
            if (searchViewModel.searchQuery != "") {
                FriendSearchResultsView(searchViewModel: searchViewModel, userViewModel: userViewModel)
            } else {
                Text("Search for friends")
            }
            Spacer()
        }
    }
}
//
//#Preview {
//    AddFriendView(userViewModel: UserViewModel())
//}
