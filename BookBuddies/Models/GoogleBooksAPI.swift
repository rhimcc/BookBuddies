//
//  GoogleBooksAPI.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import Foundation

class BookService: ObservableObject {
    
    private var apiKey = "AIzaSyA-7vVE2PH2E9XPGfgwIP-6YvB1mwRYv8c"
    var books: [Book] = []
    
    func fetchBooks(keyword: String, completion: @escaping () -> Void) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(keyword)&key=\(apiKey)"
        performRequest(urlString: urlString, completion: completion)
    }
    func performRequest(urlString: String, completion: @escaping () -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    self.parseJSON(bookData: safeData, completion: completion)
                }
            }
            task.resume()
        }
        
        
    }
    func parseJSON(bookData: Data, completion: @escaping () -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Books.self, from: bookData)
            DispatchQueue.main.async {
                self.books = decodedData.items ?? []
                completion()
            }
        } catch {
            print("Decoding Error: \(error)")  // Print a more specific decoding error
        }
    }
}

