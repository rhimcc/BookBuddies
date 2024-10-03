//
//  SearchResultsView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: BookViewModel
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(viewModel.books) { book in
                    BookRow(bookshelfViewModel: bookshelfViewModel, book: book)
                }
                
            }.onAppear {
                bookshelfViewModel.inSearch.toggle()
            }
            if bookshelfViewModel.bookSave {
                Button {
                    bookshelfViewModel.bookPreview.toggle()
                } label : {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                }
                if let currentBook = bookshelfViewModel.currentBookSave {
                    SaveBookView(bookshelfViewModel: bookshelfViewModel, book: currentBook)
                }
            
            }
            
           
        }
    }
}



//#Preview {
//    SearchResultsView()
//}
