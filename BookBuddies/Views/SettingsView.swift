//
//  SettingsView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 8/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
                .bold()
            VStack (alignment: .leading){
                List {
                    Section(header: Text("Profile")) { // shows the user their profile variables
                        SettingsRow(field:"User ID", value: userViewModel.currentUser.id)
                        SettingsRow(field: "Display Name", value: userViewModel.currentUser.displayName)
                        SettingsRow(field: "Email", value: userViewModel.currentUser.email)
                    }
                    
                    Section(header: Text("Stats")) { // shows some stats for the users enjoyment
                        SettingsRow(field:"Total Books", value: "\(bookshelfViewModel.getBookTotal())")
                        SettingsRow(field: "Books Read", value: "\(bookshelfViewModel.getBooksRead())")
                    } .onAppear {
                        userViewModel.loadBooksFromFirestore(user: userViewModel.currentUser) { fetchedBooks in
                              DispatchQueue.main.async {
                                  bookshelfViewModel.currentUserBooks = fetchedBooks // Updates the published books
                              }
                        }
                    }
                }
            } .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 15).fill(.lightPeach))
            Button ("SIGN OUT") { // button to let the user sign out
                authViewModel.signOut()
            }.buttonStyle(.borderedProminent)
                .tint(.navy)
                .bold()
        }
        
    }
}

struct SettingsRow: View { // defines the layout of each row in the settings list
    var field: String
    var value: String
    
    var body: some View {
        HStack {
            Text(field)
            Spacer()
            Text(value)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

//#Preview {
//    SettingsView()
//}
