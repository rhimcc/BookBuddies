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
