import Foundation
import FirebaseFirestore
import FirebaseAuth // Import FirebaseAuth to access the user's ID

class UserViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var friends: [User] = []
    @Published var allUsers: [User] = []
    @Published var currentUser: User = User(id: "", email: "", displayName: "")
    
    init() {
        loadFriendsToArray()
        loadUsersToArray()
        getUser()
    }


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
    
    func loadFriendsToArray(){
        UserViewModel.loadFriends() { users in
            DispatchQueue.main.async {
                self.friends = users
            }
        }
    }
    
    func loadUsersToArray() {
        UserViewModel.loadUsers() { users in
            DispatchQueue.main.async {
                self.allUsers = users
            }
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
    
    static func loadFriends(completion: @escaping ([User]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("friends").getDocuments { (snapshot, error) in
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
                    print(user.displayName)
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    func removeFriendFromFirestore(user: User) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        do {
            try db.collection("users").document(userId).collection("friends").document(user.id).delete()
          print("Document successfully removed!")
        } catch {
          print("Error removing document: \(error)")
        }
   
       
        }
    
    func addFriendToFirestore(user: User) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        let userToCheck = user
        isFriend(user: userToCheck) { isFriend in
            if isFriend {
                print("User is a friend.")
            } else {
                do {
                    let jsonData = try JSONEncoder().encode(user)
                    let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    self.db.collection("users").document(userId).collection("friends").document(user.id).setData(jsonDict ?? [:]) { error in
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
        
        
    }
    
    func isFriend(user: User, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            completion(false)
            return
        }
        
        let collectionRef = db.collection("users").document(userId).collection("friends")
        collectionRef.whereField("id", isEqualTo: user.id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking if friend exists: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // If querySnapshot is not empty, the friend already exists
            if let snapshot = querySnapshot, !snapshot.isEmpty {
                print("Friend already exists in Firestore.")
                completion(true)
                return
            } else {
                completion(false) // Return false if friend does not exist
            }
        }
    }
    
    static func getCurrentUser(completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            completion(nil)
            return
        }
        
        let docRef = db.collection("users").document(userId)
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist")
                completion(nil)
                return
            }
            
            let data = document.data()
            if let name = data?["displayName"] as? String,
               let email = data?["email"] as? String {
                let user = User(id: userId, email: email, displayName: name)
                completion(user)
            } else {
                print("Failed to parse user data")
                completion(nil)
            }
        }
    }
    
    func getUser() {
        UserViewModel.getCurrentUser() { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.currentUser = user
                }
            }
        }
    }
}
    

