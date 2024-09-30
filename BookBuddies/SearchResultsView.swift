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
        Text("\(viewModel.searchQuery)")
        ForEach(viewModel.bookService.books) { book  in
            Text("\(book.volumeInfo?.title)") // Display each book title
            }
        
    }
    
}


//#Preview {
//    SearchResultsView()
//}
