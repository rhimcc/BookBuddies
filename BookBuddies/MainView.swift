//
//  MainView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 4/10/2024.
//

import SwiftUI

struct MainView: View {
    @State var tabSelection: Int = 0
    @ObservedObject var viewModel = BookshelfViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    var body: some View {
        Button ("Sign out") {
            authViewModel.signOut()
        }
        TabView(selection: $tabSelection) {
            SearchBaseView(bookshelfViewModel: viewModel, userViewModel: userViewModel)
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
            FriendView(userViewModel: userViewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "person.3")
                        Text("Friends")
                    }
                
                }.tag(0)
            
        }.tint(.navy)
    }
}

//#Preview {
//    MainView()
//}
