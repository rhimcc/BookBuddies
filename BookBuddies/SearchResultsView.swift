//
//  SearchResultsView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: BookViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.books) { book in
                BookRow(book: book)
            }
        }
    }
}



//#Preview {
//    SearchResultsView()
//}
