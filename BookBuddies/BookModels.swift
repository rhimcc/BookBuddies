//
//  BookModels.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import Foundation

struct Books: Decodable {
    let items: [Book]?
}


struct Book: Decodable, Identifiable{
    let id: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    
    func convertURL() -> String {
        var imageURL: String = volumeInfo?.imageLinks?.thumbnail ?? ""
        imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
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
}


struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let smallThumbnail: String
    let thumbnail: String
}
