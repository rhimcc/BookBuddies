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
                VStack(alignment: .leading) {
                    // Display the book's thumbnail, if available
                    if let thumbnail = book.volumeInfo?.imageLinks?.thumbnail {
                        AsyncImage(url: URL(string: thumbnail)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                            } else if phase.error != nil {
                                Text("Error loading image")
                            } else {
                                ProgressView() // Show a loading spinner while the image is loading
                            }
                        }
                    } else {
                        Text("No Image Available")
                    }
                    
                    // Display the book's title, if available
                    Text(book.volumeInfo?.title ?? "No Title Available")
                        .font(.headline)
                }
                .padding()
            }
        }
    }
}



//#Preview {
//    SearchResultsView()
//}
