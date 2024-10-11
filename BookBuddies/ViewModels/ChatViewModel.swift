//
//  ChatViewModel.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import Foundation
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentUserBooks: [Book] = []
    @Published var otherUserBooks: [Book] = []
    @Published var isShowingSheet: Bool = false
    var currentUser: User? = nil
    var friend: User? = nil
    @Published var book: Book? = nil
    

    private var listener: ListenerRegistration?

    
    func startListening(user1Id: String, user2Id: String) {
        listener = Firestore.firestore().collection("users").document(user1Id).collection("friends").document(user2Id).collection("messages")
            .order(by: "time")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No messages")
                    return
                }
                self?.messages = documents.compactMap { doc in
                    try? doc.data(as: Message.self) 
                }
            }
    }
    
    func generateChatId(user1Id: String, user2Id: String) -> String {
        return [user1Id, user2Id].sorted().joined(separator: "_")
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func loadCurrentUser() {
        if let user = currentUser {
            Book.loadBooksFromFirestore(user: user) { fetchedBooks in
                DispatchQueue.main.async {
                    self.currentUserBooks = fetchedBooks
                }
            }
        }
    }
    func loadOtherUser() {
        if let user = friend {
            Book.loadBooksFromFirestore(user: user) { fetchedBooks in
                DispatchQueue.main.async {
                    self.otherUserBooks = fetchedBooks
                }
            }
        }
    }
}
