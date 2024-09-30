//
//  SearchView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: BookViewModel
    var body: some View {
        VStack {
            Text("Search")
        }
            .searchable(text: $searchViewModel.searchQuery, isPresented: $searchViewModel.searchActive, prompt: "Search...")
    }
}

//#Preview {
//    SearchView()
//}
