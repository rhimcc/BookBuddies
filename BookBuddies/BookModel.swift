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
        let a = CGFloat(data![pixelInfo + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

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
    
    func convertURL(imageURL: String) -> String? {
        var imageURL = imageURL
        if (!imageURL.isEmpty) {
            imageURL.insert("s", at: imageURL.index(imageURL.startIndex, offsetBy: 4))
        }
        return imageURL
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
    
    func getTitle() -> String {
        if let volumeInfo = self.volumeInfo {
            return volumeInfo.title
        }
        return ""
    }
    
    func getImageThumbnail() -> String? {
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



