//
//  SearchView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: BookSearchViewModel
    var body: some View {
        EmptyView()
            .searchable(text: $searchViewModel.searchQuery, isPresented: $searchViewModel.searchActive, prompt: "Search...")
    }
}

//#Preview {
//    SearchView()
//}
