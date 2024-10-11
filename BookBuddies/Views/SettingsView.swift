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
                    Section(header: Text("Profile")) {
                        SettingsRow(field:"User ID", value: userViewModel.currentUser.id)
                        SettingsRow(field: "Display Name", value: userViewModel.currentUser.displayName)
                        SettingsRow(field: "Email", value: userViewModel.currentUser.email)
                    }
                    
                    Section(header: Text("Stats")) {
                        SettingsRow(field:"Total Books", value: "\(bookshelfViewModel.getBookTotal())")
                        SettingsRow(field: "Books Read", value: "\(bookshelfViewModel.getBooksRead())")
                    } .onAppear {
                        Book.loadBooksFromFirestore(user: userViewModel.currentUser) { fetchedBooks in
                              DispatchQueue.main.async {
                                  bookshelfViewModel.currentUserBooks = fetchedBooks // Update the published books
                              }
                        }
                    }
                }
            
             
                
            } .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 15).fill(.lightPeach))
            Button ("SIGN OUT") {
                authViewModel.signOut()
            }.buttonStyle(.borderedProminent)
                .tint(.navy)
                .bold()
        }
        
    }
    //Change email
    // Change colour
    // sign out
}

struct SettingsRow: View {
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
