import Foundation
import FirebaseFirestore
import FirebaseAuth // Import FirebaseAuth to access the user's ID

class UserViewModel: ObservableObject {
    let db = Firestore.firestore()

    func addBookToFirestore(book: Book) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(book)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            db.collection("users").document(userId).collection("books").addDocument(data: jsonDict ?? [:]) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document successfully added")
                }
            }
        } catch {
            print("Error encoding book: \(error.localizedDescription)")
        }
    }
    
    static func loadUsers(completion: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error loading users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var users: [User] = []
            for document in snapshot!.documents {
                let data = document.data()
                
                if let id = data["id"] as? String, let email = data["email"] as? String, let displayName = data["displayName"] as? String {
                    
                    let user = User(id: id, email: email, displayName: displayName)
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    func addFriendToFirestore(user: User) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            db.collection("users").document(userId).collection("friends").addDocument(data: jsonDict ?? [:]) { error in
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                } else {
                    print("User successfully added")
                }
            }
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }
}
