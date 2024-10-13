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
    let userViewModel = UserViewModel()
    

    private var listener: ListenerRegistration?

    
    func startListening(user1Id: String, user2Id: String) { // listens to the chat, so that the view can update if the user receives a new message
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
    
    
    func stopListening() { // removes the listener, to stop listening
        listener?.remove()
    }
    
    func loadCurrentUser() { // loads the current users books
        if let user = currentUser {
            userViewModel.loadBooksFromFirestore(user: user) { fetchedBooks in
                DispatchQueue.main.async {
                    self.currentUserBooks = fetchedBooks
                }
            }
        }
    }
    func loadOtherUser() { // loads the friends books
        if let user = friend {
            userViewModel.loadBooksFromFirestore(user: user) { fetchedBooks in
                DispatchQueue.main.async {
                    self.otherUserBooks = fetchedBooks
                }
            }
        }
    }
}
