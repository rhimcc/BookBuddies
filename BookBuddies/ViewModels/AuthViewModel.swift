//
//  AuthViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 4/10/2024.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            
            strongSelf.isSignedIn = true
        }
    }
    
    func createAccount(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            strongSelf.isSignedIn = true
            strongSelf.errorMessage = "Sign in successful"
        }
    }
    
    func passwordsMatch(password: String, confirmPassword: String) -> Bool {
        if password == confirmPassword {
            return true
        } else {
            errorMessage = "Passwords do not match"
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Successfully signed out")
            isSignedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
