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
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let cgImage = self.cgImage,
              let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data else {
            return nil
        }
        
        let data = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        let width = cgImage.width
        let pixelInfo = ((Int(width) * Int(point.y)) + Int(point.x)) * bytesPerPixel

        let r = CGFloat(data![pixelInfo]) / 255.0
        let g = CGFloat(data![pixelInfo + 1]) / 255.0
        let b = CGFloat(data![pixelInfo + 2]) / 255.0
        let a = CGFloat(1)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

struct Books: Decodable {
    let items: [Book]?
}


@Model
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
    let category: String?
    let pageCount: Int?
    var userPage: Int?
    
    func convertURL(imageURL: String) -> String? {
        var imageURL = imageURL
        if (!imageURL.isEmpty) {
            imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
        }
        return imageURL
    }
    static func == (lhs: Book, rhs: Book) -> Bool {
            return lhs.id == rhs.id // Ensure you're comparing by a unique identifier
        }
    
    func getDescriptionFromJSON() -> String {
        if let volumeInfo = volumeInfo, let desc = volumeInfo.desc {
            return desc
        }
        return ""
    }
    
    func getCategoryFromJSON() -> String {
        if let volumeInfo = volumeInfo, let category = volumeInfo.category {
            return category
        }
        return ""
    }
    
    func getPageCount() -> Int {
        if let volumeInfo = volumeInfo, let pageCount = volumeInfo.pageCount{
            return pageCount
        }
        return 0
    }
    
    func getAuthorStringFromJSON() -> String {
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
    
    func getAuthorString() -> String {
        if let authors = authors {
            return authors
        }
        return ""
    }
    
    func getTitleFromJSON() -> String {
        if let volumeInfo = self.volumeInfo {
            return volumeInfo.title
        }
        return ""
    }
    
    func getImageThumbnailFromJSON() -> String? {
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
            completion(Color.gray) // Return a default color if URL conversion fails
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data, let loadedImage = UIImage(data: data) else {
                print("Failed to load image from URL: \(urlString)")
                completion(Color.gray) // Return a default color if fetching fails
                return
            }
            
            let point = CGPoint(x: 0, y: loadedImage.size.height / 2)
            
            if let uiColor = loadedImage.getPixelColor(at: point) {
                completion(Color(uiColor))
            } else {
                completion(Color.gray) // Return a default color if color extraction fails
            }
        }
        
        // Start the data task
        task.resume()
    }

    
    init(id: String?, title: String, authors: String, bookshelf: String, image: String, readStatus: String, desc: String, pageCount: Int, category: String, userPage: Int){ // initalising all values for books
        self.id = id
        self.title = title
        self.authors = authors
        self.bookshelf = bookshelf
        self.image = image
        self.readStatus = readStatus
        self.desc = desc
        self.pageCount = pageCount
        self.category = category
        self.userPage = userPage
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
        }
    
    enum CodingKeys: String, CodingKey {
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
    
    func printBook() {
        print(id, title, authors, bookshelf, readStatus, image)
        
    }
    
    func encode(to encoder: Encoder) throws {
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
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(userPage, forKey: .userPage)

    }
    
    
    
}
extension Book {
    static func loadBooksFromFirestore(user: User, completion: @escaping ([Book]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(user.id).collection("books").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error loading books: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var books: [Book] = []
            for document in snapshot!.documents {
                let data = document.data()
                
                // Decode the book properties
                if let id = data["id"] as? String,
                   let title = data["title"] as? String,
                   let authors = data["authors"] as? String,
                   let bookshelf = data["bookshelf"] as? String,
                   let image = data["image"] as? String,
                   let readStatus = data["readStatus"] as? String,
                   let desc = data["description"] as? String,
                   let pageCount = data["pageCount"] as? Int,
                   let userPage = data["userPage"] as? Int,
                   let category = data["category"] as? String
                {
                    let book = Book(id: id, title: title, authors: authors, bookshelf: bookshelf, image: image, readStatus: readStatus, desc: desc, pageCount: Int(pageCount) ?? 0, category: category, userPage: Int(userPage) ?? 0)
                    books.append(book)
                }
            }
            completion(books)
        }
    }
}




