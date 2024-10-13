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
    let desc: String?
    let category: String?
    let pageCount: Int?
    
    init(title: String, authors: [String]?, imageLinks: ImageLinks?, desc: String?, category: String?, pageCount: Int?) { // initialiser to create instances
        self.title = title
        self.authors = authors
        self.imageLinks = imageLinks
        self.desc = desc
        self.category = category
        self.pageCount = pageCount
        
    }
    
    init(from decoder: Decoder) throws { //initialises all of the variables from JSON decoding
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.authors = try container.decodeIfPresent([String].self, forKey: .authors)
        self.imageLinks = try container.decodeIfPresent(ImageLinks.self, forKey: .imageLinks)
        self.desc = try container.decodeIfPresent(String.self, forKey: .description)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
    }
    
    enum CodingKeys: String, CodingKey { //coding keys for the decoding of JSON objects
        case title
        case authors
        case imageLinks
        case description
        case category
        case pageCount
    }
    
    func encode(to encoder: Encoder) throws { // encoding the variables for JSON
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(imageLinks, forKey: .imageLinks)
        try container.encodeIfPresent(desc, forKey: .description)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(pageCount, forKey: .pageCount)
    }
}
