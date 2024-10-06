//
//  SearchBaseQuery.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI

struct SearchBaseView: View {
    @StateObject private var searchViewModel: BookViewModel = BookViewModel()
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        NavigationStack {
            SearchView(searchViewModel: searchViewModel) // always shows the search view (just search bar)

            if (searchViewModel.searchActive) {
                SearchResultsView(viewModel: searchViewModel, bookshelfViewModel: bookshelfViewModel, userViewModel: userViewModel) // shows the results of the search if its active

            } else {
                Text("Search not active") // shows the suggested topics if the search isnt active
            }
        }
    
    }
}

//#Preview {
//    SearchBaseQuery()
//}
