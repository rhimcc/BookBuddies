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
    let bookshelf: String?
    let image: String?
    let readStatus: String?
    let desc: String?
    let title: String?
    let authors: String?
    
    func convertURL() -> String {
        var imageURL: String = volumeInfo?.imageLinks?.thumbnail ?? ""
        if (!imageURL.isEmpty) {
            imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
        }
        return imageURL
    }
    
    func getAuthorString() -> String {
        if let volumeInfo = volumeInfo, let authors = volumeInfo.authors {
            print(authors)
            if authors.count == 1 {
                return authors[0]
            }
            if authors.count == 2 {
                return authors[0] + ", " + authors[1]
            }
            if authors.count > 2 {
                return authors[0] + ", " + authors[1] + ", + \(authors.count - 2) more"
            }
        }
        return ""
    }
    
    func getTitle() -> String {
        if let volumeInfo = self.volumeInfo {
            return volumeInfo.title
        }
        return ""
    }
    
    func getImageThumbnail() -> String {
        if let volumeInfo = self.volumeInfo {
            if let imageLinks = volumeInfo.imageLinks {
                return imageLinks.thumbnail
            }
        }
        return ""
    }
    
    init(id: String?, title: String, authors: String, bookshelf: String, image: String, readStatus: String){ // initalising all values for books
        self.id = id
        self.title = title
        self.authors = authors
        self.bookshelf = bookshelf
        self.image = image
        self.readStatus = readStatus
    }
    
    required init(from decoder: Decoder) throws { //initialises all of the variables for JSON decoding
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.selfLink = try container.decodeIfPresent(String.self, forKey: .selfLink)
        self.volumeInfo = try container.decodeIfPresent(VolumeInfo.self, forKey: .volumeInfo)
        self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
        
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case selfLink
        case volumeInfo
        case desc
    }
}



