//
//  AddFriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import SwiftUI

struct AddFriendView: View {
    @ObservedObject var userViewModel: UserViewModel
    @StateObject var searchViewModel: SearchViewModel = SearchViewModel()
    var body: some View {
        VStack {
            Text("Add Friends")
                .font(.title)
                .bold()
            TextField("Search by name", text: $searchViewModel.searchQuery) // lets user search
                .padding(.horizontal, 10)
                .textFieldStyle(.roundedBorder)
            if (searchViewModel.searchQuery != "") {
                FriendSearchResultsView(searchViewModel: searchViewModel, userViewModel: userViewModel) // if there is text in search query
            }
            Spacer()
        }
    }
}
//
//#Preview {
//    AddFriendView(userViewModel: UserViewModel())
//}
