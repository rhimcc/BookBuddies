//
//  VolumeInfoModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import Foundation
import SwiftData

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let imageLinks: ImageLinks?
    
    init(title: String, authors: [String]?, imageLinks: ImageLinks?) {
        self.title = title
        self.authors = authors
        self.imageLinks = imageLinks
    }
    
     init(from decoder: Decoder) throws { //initialises all of the variables for JSON decoding
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.authors = try container.decodeIfPresent([String].self, forKey: .authors)
        self.imageLinks = try container.decodeIfPresent(ImageLinks.self, forKey: .imageLinks)

        }
        
        enum CodingKeys: String, CodingKey { //coding keys for the decoding of JSON objects
            case title
            case authors
            case imageLinks
        }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
    }
}
