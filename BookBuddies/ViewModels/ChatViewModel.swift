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
}
