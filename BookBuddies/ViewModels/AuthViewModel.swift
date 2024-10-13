//
//  AuthViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 4/10/2024.
//

import Foundation
import FirebaseAuth
import Combine
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var errorMessage: String?
    let db = Firestore.firestore()
    
    func signIn(withEmail email: String, password: String) { // facilitates the sign in
        // sttempt to sign in using firebase authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // capture a strong reference to self to avoid retain cycles
            guard let strongSelf = self else { return }
            
            //checks for errors
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            //sets the signed in status to true
            strongSelf.isSignedIn = true
        }
    }
    
    func createAccount(withEmail email: String, displayName: String, password: String) { // allows the user to create an account
        // create user with firebase authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            // capture a strong reference to self to avoid retain cycles
            guard let strongSelf = self else { return }
            
            //checks for errors
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            // sets signed in status to true
            strongSelf.isSignedIn = true
            //creates a new user from the data
            let newUser = User(id: Auth.auth().currentUser?.uid ?? "", email: email, displayName: displayName, status: nil)
            self?.addAccountToFirestore(user: newUser) // adds the account to the firestore
            
        }
    
        
    }
    
    func addAccountToFirestore(user: User) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else { // gets the userId of the current user
            print("User not authenticated or invalid user ID.")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(user) // creates data from the user
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates a dict from the data
            db.collection("users").document(userId).setData(jsonDict ?? [:]) { error in // sets the data for the user id with the dict
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                } else {
                    print("User successfully added")
                }
            }
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }
    
    func passwordsMatch(password: String, confirmPassword: String) -> Bool { // checks if the passwords entered by the users match
        if password == confirmPassword {
            return true
        } else {
            errorMessage = "Passwords do not match"
            return false
        }
    }
    
    func signOut() { // signs the user out of their account
        do {
            try Auth.auth().signOut() // signs out through authentication
            print("Successfully signed out")
            isSignedIn = false // stores the signout status
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
