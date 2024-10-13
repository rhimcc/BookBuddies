//
//  GoogleBooksAPI.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import Foundation

class BookService: ObservableObject {
    
    private var apiKey = "AIzaSyA-7vVE2PH2E9XPGfgwIP-6YvB1mwRYv8c" // key to connect to API
    var books: [Book] = []
    
    func fetchBooks(keyword: String, completion: @escaping () -> Void) { // creates the link for the search, calls function to complete search
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(keyword)&key=\(apiKey)"
        performRequest(urlString: urlString, completion: completion)
    }
    func performRequest(urlString: String, completion: @escaping () -> Void) { // creates session
        if let url = URL(string: urlString) { // create URL for search
            let session = URLSession(configuration: .default) // initalise session
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                if let safeData = data {
                    self.parseJSON(bookData: safeData, completion: completion) // parse JSON to retrieve data
                }
            }
            task.resume()
        }
        
        
    }
    func parseJSON(bookData: Data, completion: @escaping () -> Void) { // parses the decodes the data for data that is usable
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Books.self, from: bookData) // Decoding the books
            DispatchQueue.main.async {
                self.books = decodedData.items ?? [] // storing books for later use
                completion()
            }
        } catch {
            print("Decoding Error: \(error)")  // Prints decoding error
        }
    }
}

