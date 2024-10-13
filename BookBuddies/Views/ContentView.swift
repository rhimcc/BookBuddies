//
//  ContentView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if authViewModel.isSignedIn {
                MainView(authViewModel: authViewModel) // if the user is signed in, goes to the main view
            } else {
                StartView(authViewModel: authViewModel) // if the user isnt signed in, it puts them in the view to let them sign in or sign up
            }
        }
        .onAppear {
            checkUserSignInStatus() // checks the status when the view appears
        }
    }

    func checkUserSignInStatus() { // updates the status of the user sign in
        if let user = Auth.auth().currentUser {
            authViewModel.isSignedIn = true
        } else {
            authViewModel.isSignedIn = false
        }
    }
}

#Preview {
    ContentView(authViewModel: AuthViewModel())
}

