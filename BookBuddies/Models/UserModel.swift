//
//  UserModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 5/10/2024.
//

import Foundation
import FirebaseAuth

class User: Identifiable, Codable {
    var id: String
    var email: String
    var displayName: String
    
    static func getCurrentUser() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    init(id: String, email: String, displayName: String) {
        self.id = id
        self.email = email
        self.displayName = displayName
    }
    
    required init(from decoder: Decoder) throws { //initialises all of the variables for JSON decoding
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(displayName, forKey: .displayName)


    
    }
    
    
}
