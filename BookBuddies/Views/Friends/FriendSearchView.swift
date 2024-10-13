//
//  FriendSearchView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import SwiftUI

struct FriendSearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    var body: some View {
        EmptyView()
            .searchable(text: $searchViewModel.searchQuery, isPresented: $searchViewModel.isActive, prompt: "Search...")
    }
}

//#Preview {
//    FriendSearchView()
//}
