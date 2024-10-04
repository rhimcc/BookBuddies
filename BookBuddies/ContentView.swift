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
//    @State private var isSignedIn: Bool = false
    
    var body: some View {
        VStack {
            if authViewModel.isSignedIn {
                MainView(authViewModel: authViewModel)
            } else {
                SignInView()
            }
        }
        .onAppear {
            checkUserSignInStatus()
        }
    }

    func checkUserSignInStatus() {
        if let user = Auth.auth().currentUser {
            print("User is signed in: \(user.email ?? "No email")")
            authViewModel.isSignedIn = true
        } else {
            print("No user is signed in")
            authViewModel.isSignedIn = false
        }
    }
}
