import Foundation
import FirebaseFirestore
import FirebaseAuth // Import FirebaseAuth to access the user's ID

class UserViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var friends: [User] = []
    @Published var allUsers: [User] = []
    @Published var currentUser: User = User(id: "", email: "", displayName: "", status: "")
    @Published var shareSheet: Bool = false
    @Published var friendsReading: [String: [Book]] = [:]
    
    init() {
        loadUsersToArray()
        getUser()
        loadFriendsToArray() { // will only load the friend's books after the friends have completed loading
            self.getFriendsBooks()
        }
    }

    func removeBook(book: Book) { // allows the user to remove a book from their bookshelf
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        if let id = book.id {
            db.collection("users").document(userId).collection("books").document(id).delete() // deletes the document from the firestore database
        }
    }
    

    func addBookToFirestore(book: Book) { // allows the user to add a book to the firestore
        guard let userId = Auth.auth().currentUser?.uid else { // gets the current user's id
            print("User not authenticated.")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(book) // encodes data to json
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates dict with the values
            if let id = book.id {
                db.collection("users").document(userId).collection("books").document(id).setData(jsonDict ?? [:]) { error in // creates a new document if book does not exist in the firestore
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully added")
                    }
                }
            }
        } catch {
            print("Error encoding book: \(error.localizedDescription)")
        }
    }
    
    func approveFriend(friend: User) { // allows the user to approve any friend requests they have received
        addFriendToFirestore(friend: currentUser, to: friend, status: "Friends") // adds the current user as a friend to the friend's document
        db.collection("users").document(currentUser.id).collection("friends").document(friend.id).setData([ "status": "Friends" ], merge: true) // updates the status from the current users friend document from Pending to Friends
        if let index = friends.firstIndex(where: { $0.id == friend.id }) {
              friends[index].status = "Friends" // updates the local storage of the friend status
              friends = friends.map { $0 } // used to publish the changes
          }
       
    }
    
    func loadFriendsToArray(completion: @escaping () -> Void) { // loads the user's friends to a local array
        UserViewModel.loadFriends() { users in
            DispatchQueue.main.async {
                self.friends = users
                completion() // Call completion after loading friends
            }
        }
    }
    
    func loadUsersToArray() { // loads the users to a local array
        UserViewModel.loadUsers() { users in
            DispatchQueue.main.async {
                self.allUsers = users
            }
        }
    }
    
    func getFriendsBooks() { // get the books for each friend, filter by reading, and store in local dict
        for friend in friends {
            loadBooksFromFirestore(user: friend) { fetchedBooks in
                DispatchQueue.main.async {
                    self.friendsReading[friend.id] = fetchedBooks.filter {$0.readStatus == "Reading"}
                }
            }
        }
    }
    
    static func loadUsers(completion: @escaping ([User]) -> Void) { // loads the users into an array
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in // gets all documents that are stored in "users" in firestore
            if let error = error {
                print("Error loading users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var users: [User] = [] // initialises local array
            for document in snapshot!.documents {
                let data = document.data()
                
                if let id = data["id"] as? String, let email = data["email"] as? String, let displayName = data["displayName"] as? String { // ensures the data is valid
                    
                    let user = User(id: id, email: email, displayName: displayName, status: nil) // initialises data for each user
                    users.append(user) // appends new user to the array
                }
            }
            completion(users) // returns the array on completion
        }
    }
    
    static func loadFriends(completion: @escaping ([User]) -> Void) { // loads the friends into an array
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("User not authenticated or invalid user ID.")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("friends").getDocuments { (snapshot, error) in // gets all documents that are stored in "friends" in the current users' doccument in firestore
            if let error = error {
                print("Error loading users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            var users: [User] = [] // initialises local array
            for document in snapshot!.documents { // iterates through each document in the collection
                let data = document.data() // gets the data from the document
                
                if let id = data["id"] as? String, let email = data["email"] as? String, let displayName = data["displayName"] as? String, let status = data["status"] as? String  { // ensures all data is valid
                    
                    let user = User(id: id, email: email, displayName: displayName, status: status) // initialises user from the stored data
                    users.append(user) // appends new user to the array
                }
            }
            completion(users) // returns user array on completion
        }
    }
    
    func removeFriendFromFirestore(friend: User, from user: User) { // removes friend from firestore, from specified users
        db.collection("users").document(user.id).collection("friends").document(friend.id).delete()
          print("Document successfully removed!")
        }
    
    func addFriendToFirestore(friend user1: User, to user2: User, status: String) { // adds friend to specified users document, with specified status
        do {
            let jsonData = try JSONEncoder().encode(user1) // encodes the friend's data
            var jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates the dict from data
            jsonDict?["status"] = status // updates the status value to the passed parameter
            self.db.collection("users").document(user2.id).collection("friends").document(user1.id).setData(jsonDict ?? [:]) { error in // sets the data of the document to the dict
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
    
    
    func isFriend(user: User, completion: @escaping (Bool) -> Void) { // checks if a user is a friend of the current user
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else { // gets the current user's id
            print("User not authenticated or invalid user ID.")
            completion(false)
            return
        }
        
        let collectionRef = db.collection("users").document(userId).collection("friends") // defines the reference for the user's friend collection
        collectionRef.whereField("id", isEqualTo: user.id).getDocuments { (querySnapshot, error) in // gets the document for the user from the current user's collection
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
    
    static func getCurrentUser(completion: @escaping (User?) -> Void) { // gets the current user
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            completion(nil)
            return
        }
        
        let docRef = db.collection("users").document(userId) // gets the document which has the userId, if it exists
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else { // checks for errors with the document
                print("Document does not exist")
                completion(nil)
                return
            }
            
            let data = document.data() // creates data from the document
            if let name = data?["displayName"] as? String,
               let email = data?["email"] as? String {
                let user = User(id: userId, email: email, displayName: name, status: nil) // creates user from the user data
                completion(user)
            } else {
                print("Failed to parse user data")
                completion(nil)
            }
        }
    }
    
    func hasPendingRequest(from currentUser: User, to friend: User, completion: @escaping (Bool) -> Void) { // checks if the user has a pending friend request from a specified user
        let docRef = db.collection("users").document(friend.id).collection("friends").document(currentUser.id) // creates a document reference
        
        docRef.getDocument { (document, error) in // tries to get the document
            if let document = document, document.exists {
                let status = document.data()?["status"] as? String
                completion(status == "Pending") // returns bool result of if it is pending
            } else {
                completion(false)
            }
        }
    }
    
    func getUser() { // gets the user, using the load function
        UserViewModel.getCurrentUser() { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.currentUser = user
                }
            }
        }
    }
    
    func storeMessage(user1: User, user2: User, message: Message) { // stores a message in firestore
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(message) // creates data from the message
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] // creates dict from the json data
            db.collection("users").document(user1.id).collection("friends").document(user2.id).collection("messages")
                .addDocument(data: jsonDict ?? [:]) { error in // creates a new document with the data
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document successfully added")
                }
            }
        } catch {
            print("Error encoding message: \(error.localizedDescription)")
        }
    }
    
    func updateStatus(book: Book, oldReadStatus: String, readStatus: String, ownerStatus: String) { // updates the status of the ownership or reading status of the user for a specific book
        guard let userId = Auth.auth().currentUser?.uid else { // gets the current userId
            print("User not authenticated.")
            return
        }
        
        do {
            if let id = book.id {
                db.collection("users").document(userId).collection("books").document(id).setData([ "readStatus": readStatus ], merge: true) // updates the readStatus with the new value
                db.collection("users").document(userId).collection("books").document(id).setData([ "bookshelf": ownerStatus ], merge: true) // updates the owner status with the new value
                if (readStatus != "Read") {
                    db.collection("users").document(userId).collection("books").document(id).setData([ "userPage": 0 ], merge: true) // resets the user page count to 0 if the new value is Unread or Reading
                    book.userPage = 0
                } else {
                    if let pageCount = book.pageCount { // updates the pages read to match the book's page amount as it will have been read
                        db.collection("users").document(userId).collection("books").document(id).setData([ "userPage": pageCount], merge: true)
                        book.userPage = pageCount
                    }
                }
            }
        }
    }
    func loadBooksFromFirestore(user: User, completion: @escaping ([Book]) -> Void) {
        let db = Firestore.firestore() // connecting to database
        
            DispatchQueue.main.async {
                        db.collection("users").document(user.id).collection("books").getDocuments { (snapshot, error) in // gets the book documents from the specified collection
                        if let error = error {
                            print("Error loading books: \(error.localizedDescription)")
                            completion([])
                            return
                        }
                        
                        var books: [Book] = [] // initialising array to store books
                        for document in snapshot!.documents { // iterates through the array to get each individual book document
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
                               let userPage = data["userPage"] as? Int
                            {
                                let book = Book(id: id, title: title, authors: authors, bookshelf: bookshelf, image: image, readStatus: readStatus, desc: desc, pageCount: Int(pageCount), userPage: Int(userPage)) // creates the book
                                books.append(book) // appends book to the array
                            }
                        }
                        completion(books) // returns the books on completion
                    }
                
            }
        
       
    }
    
    
    func updateUserPage(userPage: Int, book: Book) { // updates the users amount of pages read
        guard let userId = Auth.auth().currentUser?.uid else { // gets user's id
            print("User not authenticated.")
            return
        }
        
        do {
            if let id = book.id {
                db.collection("users").document(userId).collection("books").document(id).setData([ "userPage": userPage ], merge: true) // updates the book stored via id with the field "userPage"
            }
        }
    }
    
    func getFriendFromID(id: String) -> User? { // returns a friend of the user from their id, if it exists
        if let friend = friends.first(where: {$0.id == id}) {
            return friend
        }
        return nil
    }
}
    

