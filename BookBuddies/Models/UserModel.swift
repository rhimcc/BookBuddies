//
//  UserModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 5/10/2024.
//

import Foundation
import FirebaseAuth

struct User {
    static func getCurrentUser() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
