//
//  ImageLinks.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import Foundation
import SwiftData

struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
    
    init(smallThumbnail: String, thumbnail: String) { // initialising images
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
    }
    
    init(from decoder: Decoder) throws { // initialises all of the variables from JSON decoding
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.smallThumbnail = try container.decode(String.self, forKey: .smallThumbnail)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
    }
        
    enum CodingKeys: String, CodingKey { //coding keys for the decoding of JSON objects
        case smallThumbnail
        case thumbnail
    }
    
    func encode(to encoder: Encoder) throws { // encoding for JSON
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(smallThumbnail, forKey: .smallThumbnail)
        try container.encode(thumbnail, forKey: .thumbnail)
    }
}
