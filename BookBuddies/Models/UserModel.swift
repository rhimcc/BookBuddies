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
    var status: String?
    
    static func getCurrentUser() -> String { // returns the id for the current user
        return Auth.auth().currentUser?.uid ?? ""
    }
        
    init(id: String, email: String, displayName: String, status: String?) { // initialising users
        self.id = id
        self.email = email
        self.displayName = displayName
        self.status = status
    }
    
    required init(from decoder: Decoder) throws { //initialises all of the variables from JSON decoding
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
    
    enum CodingKeys: String, CodingKey { // coding keys for encoding and decoding the data
        case id
        case email
        case displayName
        case status
    }
    
    func encode(to encoder: Encoder) throws { // encoding data for JSON
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(displayName, forKey: .displayName)
        try container.encodeIfPresent(status, forKey: .status)
    }
}
