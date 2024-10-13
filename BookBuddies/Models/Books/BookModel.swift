//
//  BookModels.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 1/10/2024.
//

import Foundation
import SwiftUI
import SwiftData
import UIKit
import FirebaseFirestore

extension UIImage {
    func getPixelColor(at point: CGPoint) -> UIColor? { // gets the pixel colour for book spines
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data else {
            return nil
        }
        // converts pixel point into a byte pointer
        let data = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4 // specifies the size of byte
        let width = cgImage.width // gets width of image
        let pixelInfo = ((Int(width) * Int(point.y)) + Int(point.x)) * bytesPerPixel // calculates the index of the pixel

        let r = CGFloat(data![pixelInfo]) / 255.0 // red value
        let g = CGFloat(data![pixelInfo + 1]) / 255.0 // green value
        let b = CGFloat(data![pixelInfo + 2]) / 255.0 // blue value
        let a = CGFloat(1) // sets alpha to 1 for full opacity

        return UIColor(red: r, green: g, blue: b, alpha: a) // returns colour
    }
}

struct Books: Decodable {
    let items: [Book]?
}


class Book: Codable, Identifiable, Equatable {
    let id: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    var bookshelf: String?
    let image: String?
    var readStatus: String?
    let title: String?
    let authors: String?
    let desc: String?
    let pageCount: Int?
    var userPage: Int?
    
    func convertURL(imageURL: String) -> String? {
        var imageURL = imageURL
        if (!imageURL.isEmpty) {
            imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
        }
        return imageURL // adds an s to the link to allow for secure connection
    }
    static func == (lhs: Book, rhs: Book) -> Bool {
            return lhs.id == rhs.id // allows for equating the books by their unique identifier
        }
    
    func getDescriptionFromJSON() -> String { // gets the book description from the JSON
        if let volumeInfo = volumeInfo, let desc = volumeInfo.desc {
            return desc
        }
        return ""
    }
    
    func getPageCount() -> Int { // gets the page count from the JSON
        if let volumeInfo = volumeInfo, let pageCount = volumeInfo.pageCount{
            return pageCount
        }
        return 0
    }
    
    func getAuthorStringFromJSON() -> String { // gets the authors from the JSON, and returns them as a formatted string
        if let volumeInfo = volumeInfo, let authors = volumeInfo.authors {
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
    
    func getAuthorString() -> String { // gets author string after it has been stored in a book
        if let authors = authors {
            return authors
        }
        return ""
    }
    
    func getTitleFromJSON() -> String { // gets title from the JSON
        if let volumeInfo = self.volumeInfo {
            return volumeInfo.title
        }
        return ""
    }
    
    func getImageThumbnailFromJSON() -> String? { // gets the image thumbnail from the JSON
        if let volumeInfo = self.volumeInfo {
            if let imageLinks = volumeInfo.imageLinks {
                return imageLinks.thumbnail
            }
        }
        return nil
    }
    
    func getImageColour(completion: @escaping (Color) -> Void) {
        guard let image = image,
              let urlString = convertURL(imageURL: image),
              let url = URL(string: urlString) else {
            completion(Color.gray) // Returns a default colour if URL conversion fails
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data, let loadedImage = UIImage(data: data) else { // gets the data from the image
                print("Failed to load image from URL: \(urlString)")
                completion(Color.gray) // Return a default colour if fetching fails
                return
            }
            
            let point = CGPoint(x: 0, y: loadedImage.size.height / 2) // defines the point for the pixel
            
            if let uiColor = loadedImage.getPixelColor(at: point) { // calls the function to retrieve the colour of the pixel
                completion(Color(uiColor))
            } else {
                completion(Color.gray) // Return a default colour if colour extraction fails
            }
        }
        
        // Start the data task
        task.resume()
    }

    
    init(id: String?, title: String, authors: String, bookshelf: String, image: String, readStatus: String, desc: String, pageCount: Int, userPage: Int){ // initalising all values for books
        self.id = id
        self.title = title
        self.authors = authors
        self.bookshelf = bookshelf
        self.image = image
        self.readStatus = readStatus
        self.desc = desc
        self.pageCount = pageCount
        self.userPage = userPage
        self.selfLink = ""
        self.volumeInfo = nil
    }
    
    required init(from decoder: Decoder) throws { //initialises all of the variables for JSON decoding
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.selfLink = try container.decodeIfPresent(String.self, forKey: .selfLink)
        self.volumeInfo = try container.decodeIfPresent(VolumeInfo.self, forKey: .volumeInfo)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.desc = try container.decodeIfPresent(String.self, forKey: .description)
        self.authors = try container.decodeIfPresent(String.self, forKey: .authors)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        }
    
    enum CodingKeys: String, CodingKey { // specifying the coding keys to encode/decode books
        case id
        case selfLink
        case volumeInfo
        case description
        case bookshelf
        case image
        case readStatus
        case title
        case authors
        case category
        case pageCount
        case userPage
    }
    
    func encode(to encoder: Encoder) throws { // encoding the variables to store
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(selfLink, forKey: .selfLink)
        try container.encodeIfPresent(bookshelf, forKey: .bookshelf)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(readStatus, forKey: .readStatus)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(authors, forKey: .authors)
        try container.encodeIfPresent(desc, forKey: .description)
        try container.encodeIfPresent(pageCount, forKey: .pageCount)
        try container.encodeIfPresent(userPage, forKey: .userPage)

    }
    
    
    
}




