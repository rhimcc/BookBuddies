//
//  BookModels.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import Foundation
import SwiftData

struct Books: Decodable {
    let items: [Book]?
}


@Model
class Book: Decodable, Identifiable{
    let id: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let bookshelf: BookshelfModel?
    
    func convertURL() -> String {
        var imageURL: String = volumeInfo?.imageLinks?.thumbnail ?? ""
        if (!imageURL.isEmpty) {
            imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
        }
        return imageURL
    }
    
    func getAuthorString() -> String {
        if let volumeInfo = volumeInfo, let authors = volumeInfo.authors {
            if authors.count == 1 {
                return authors[0]
            } else {
                // Handle the case for multiple authors, e.g., returning a formatted string
                return authors.joined(separator: ", ")
            }
        }
        return ""
    }
    init(id: String?, selfLink: String?, volumeInfo: VolumeInfo?, bookshelf: BookshelfModel){ // initalising all values for books
        self.id = id
        self.selfLink = selfLink
        self.volumeInfo = volumeInfo
        self.bookshelf = bookshelf
    }
    
    required init(from decoder: Decoder) throws { //initialises all of the variables for JSON decoding
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.selfLink = try container.decodeIfPresent(String.self, forKey: .selfLink)
        self.volumeInfo = try container.decodeIfPresent(VolumeInfo.self, forKey: .volumeInfo)
            

        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case selfLink
        case volumeInfo
    }
}



