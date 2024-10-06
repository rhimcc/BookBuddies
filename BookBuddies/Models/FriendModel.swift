//
//  FriendModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 6/10/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Friend: Codable {
    var id: String
    var displayName: String
    var email: String
    var books: [Book]
    let db = Firestore.firestore()

    
    init(id: String, displayName: String, email: String, books: [Book]) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.books = books
    }
    
    init(from decoder: Decoder) throws { //initialises all of the variables for JSON decoding
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.books = try container.decode([Book].self, forKey: .books)
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName
        case books
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(books, forKey: .books)

    }
    
   
}
