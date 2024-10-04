//
//  ContentView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var tabSelection: Int = 0
    @ObservedObject var viewModel = BookshelfViewModel()
    var body: some View {
        TabView(selection: $tabSelection) {
            SearchBaseView(bookshelfViewModel: viewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                }.tag(0)
            Bookshelf(bookshelfViewModel: viewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "books.vertical.fill")
                        Text("Bookshelf")
                    }
                }.tag(1)
            
        }.tint(.navy)
    }
   
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
