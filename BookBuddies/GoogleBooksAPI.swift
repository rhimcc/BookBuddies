//
//  GoogleBooksAPI.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import Foundation

class BookService: ObservableObject {
    
    private var apiKey = "AIzaSyA-7vVE2PH2E9XPGfgwIP-6YvB1mwRYv8c"
    @Published var books: [Book] = []
    func fetchBook(keyword: String) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(keyword)&key=\(apiKey)"
        
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    self.parseJSON(bookData: safeData)
                }
            }
            task.resume()
        }
        
        
    }
    func parseJSON(bookData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Books.self, from: bookData)
            DispatchQueue.main.async {
                self.books = decodedData.items ?? []
            }
        } catch {
            print("Decoding Error: \(error)")  // Print a more specific decoding error
        }
    }
        
}

struct Books: Decodable {
    let items: [Book]?
}


struct Book: Decodable, Identifiable{
    let id: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
}
