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
            VStack {
                HStack {
                    Text("User id:")
                    Text(userViewModel.currentUser.id)
                }
                Button ("Sign out") {
                    authViewModel.signOut()
                }
            } .frame(maxWidth: .infinity)
                .frame(height: 200)
            
  
            
        }
        
    }
    //Change email
    // Change colour
    // sign out
}

//#Preview {
//    SettingsView()
//}
