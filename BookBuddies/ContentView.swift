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
    var body: some View {
        TabView(selection: $tabSelection) {
            SearchBaseView()
                .tabItem {
                    Text("Search")
                
                }.tag(0)
            Bookshelf()
                .tabItem {
                    Text("Bookshelf")
                
                }.tag(1)
            
        }
    }
   
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
