//
//  MessageModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import Foundation

class Message: Codable, Identifiable, Equatable {
    
    var id: UUID
    var senderId: String
    var receiverId: String
    var messageContent: String
    var book: Book?
    var time: String
    
    init(id: UUID, senderId: String, receiverId: String, messageContent: String, book: Book?, time: String) { // initialising messages
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.messageContent = messageContent
        self.book = book
        self.time = time
    }
    
    required init(from decoder: any Decoder) throws { // decoding messages from JSON
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.senderId = try container.decode(String.self, forKey: .senderId)
        self.receiverId = try container.decode(String.self, forKey: .receiverId)
        self.messageContent = try container.decode(String.self, forKey: .messageContent)
        self.book = try container.decodeIfPresent(Book.self, forKey: .book)
        self.time = try container.decode(String.self, forKey: .time)
    }
    
    enum CodingKeys: CodingKey { // coding keys for encoding and decoding data
        case id
        case senderId
        case receiverId
        case messageContent
        case book
        case time
    }
    
    func encode(to encoder: Encoder) throws { // encoding the messages
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(senderId, forKey: .senderId)
        try container.encode(receiverId, forKey: .receiverId)
        try container.encode(messageContent, forKey: .messageContent)
        try container.encodeIfPresent(book, forKey: .book)
        try container.encode(time, forKey: .time)

    }
    
    static func ==(lhs: Message, rhs: Message) -> Bool { // equating messages, ensuring that they are the same via each variable
          return lhs.id == rhs.id &&
                 lhs.senderId == rhs.senderId &&
                 lhs.receiverId == rhs.receiverId &&
                 lhs.messageContent == rhs.messageContent &&
                 lhs.time == rhs.time &&
                 lhs.book == rhs.book
      }
    
}
