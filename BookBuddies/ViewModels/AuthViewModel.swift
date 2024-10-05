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
    
    func createAccount(withEmail email: String, displayName: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.errorMessage = error.localizedDescription
                return
            }
            strongSelf.isSignedIn = true
            strongSelf.errorMessage = "Sign in successful"
            let newUser = User(id: Auth.auth().currentUser?.uid ?? "", email: email, displayName: displayName)
            self?.addAccountToFirestore(user: newUser)
        }
        
    }
    
    func addAccountToFirestore(user: User) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            db.collection("users").document(userId).setData(jsonDict ?? [:]) { error in
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
