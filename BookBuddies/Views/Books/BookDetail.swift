//
//  BookDetail.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 2/10/2024.
//

import SwiftUI

struct BookDetail: View {
    var currentUser: User?
    var bookshelfOwner: User?
    var book: Book
    @ObservedObject var bookshelfViewModel: BookshelfViewModel
    @State private var selectedReadStatus: String = ""
    @State private var selectedBookshelf: String = ""
    @ObservedObject var userViewModel: UserViewModel
    @State var userStatuses: [String: [String]] = [:]
    @State private var navigateToChat = false
    @State private var selectedFriend: User?
    @StateObject private var chatViewModel = ChatViewModel()
    @State private var userPageText: String = ""
    @State private var editingPage: Bool = false
    @State private var validInput: Bool = false
    @State private var percentText: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var source: String
    var body: some View {
        ZStack {
            Color.veryLightPeach
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                BookView(book: book, inSearch: false) // shows book cover
                    .frame(width: 150, height: 250)
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                    .padding(.top, 10)
                
                VStack {
                    if let title = book.title { // show title
                        Text(title)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                    if let authors = book.authors { // show authors
                        Text(authors)
                            .foregroundStyle(.navy)
                    }
                    LineView()
                    if source == "self" {
                        if let book = bookshelfViewModel.currentBookPreview { // gets book from the preview
                            VStack {
                                Text("Bookshelf Status")
                                    .font(.headline)
                                HStack (alignment: .center) {
                                    Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: bookshelfViewModel.currentBookPreview?.bookshelf ?? ""))
                                    Picker("Bookshelf", selection: $selectedBookshelf) {
                                        ForEach(bookshelfViewModel.bookshelfOptions, id: \.self) { shelf in
                                            Text(shelf).tag(shelf)
                                                .bold()
                                        }
                                    }
                                    .onChange(of: selectedBookshelf) { _, newValue in // updates the owner status when the picker value is changed
                                        updateBookStatus(readStatus: book.readStatus ?? "", bookshelf: newValue)
                                    }
                                    Spacer()
                                    Image(systemName: BookshelfViewModel.getReadImage(readStatus: bookshelfViewModel.currentBookPreview?.readStatus ?? ""))
                                    Picker("Read Status", selection: $selectedReadStatus) {
                                        ForEach(bookshelfViewModel.shelfOptions, id: \.self) { status in
                                            Text(status).tag(status)
                                        }
                                    }
                                    // updates the read status when the picker value is changed
                                    .onChange(of: selectedReadStatus) { _, newValue in
                                        updateBookStatus(readStatus: newValue, bookshelf: book.bookshelf ?? "")
                                    }
                                }.padding(.horizontal, 30)
                                Button ("REMOVE"){ // lets user remove the book from their bookshelf
                                    userViewModel.removeBook(book: book)
                                    presentationMode.wrappedValue.dismiss()
                                }.buttonStyle(.borderedProminent)
                                
                                LineView()
                                if let userPage = book.userPage, let pageCount = book.pageCount { // get page count and user's page progress
                                    HStack {
                                        ProgressView(value: Float(userPage), total: Float(pageCount))
                                            .animation(.easeInOut, value: Float(userPage))
                                            .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)
                                            .padding(.top, 10)
                            
                                        Text(percentText)
                                    }
                                    
                                    VStack {
                                        if (!editingPage) { // if the user is not editing the page amount
                                            Spacer()
                                            Text("Read \(userPage) of \(String(describing: pageCount)) pages")
                                            
                                            if (book.readStatus == "Reading") { // if the user is reading the book, they can update the page amount
                                                Spacer()
                                                Button ("UPDATE"){
                                                    editingPage.toggle()
                                                    userPageText = String(userPage)
                                                }
                                                .buttonStyle(.borderedProminent)
                                                .padding(.trailing, 10)

                                            } else {
                                                Spacer()
                                            }
                                        } else {
                                            Spacer()
                                            HStack {
                                                TextField("page no..", text: $userPageText, onEditingChanged: checkFocus)
                                                    .onChange(of: userPageText) {
                                                        checkValidInput() // checks if the input is valid
                                                    }
                                                    .textFieldStyle(.roundedBorder)
                                                    .multilineTextAlignment(.trailing)
                                                    .lineLimit(1)
                                                    .frame(width: 50)
                                                Text(" of \(pageCount) pages")
                                            }
                                            Spacer()
                                            Button ("SAVE"){
                                                updatePage(userPage: userPageText) // updates the page amount
                                                editingPage.toggle() // stops the user from editing
                                                checkIfRead() // checks if the user has finsihed the book
                                                getPercent() // updates the percentage of the book progress
                                            }.disabled(!validInput) // does not let user click button if the input is invalid
                                                .padding(.trailing, 10)
                                                .buttonStyle(.borderedProminent)
                                        }
                                        
                                    }.frame(maxWidth: .infinity)
                                }
                                
                                LineView()
                            } .padding(.top, 20)
                                .onAppear {
                                    bookshelfViewModel.bookPreview.toggle() // closes the preview
                                    if let book = bookshelfViewModel.currentBookPreview, let bookshelf = book.bookshelf, let shelf = book.readStatus {
                                        selectedBookshelf = bookshelf
                                        selectedReadStatus = shelf
                                    }
                                    
                                }
                        }
                    } else {
                        if let statusArray = userStatuses[userViewModel.currentUser.id] { // shows the status of the current user
                            HStack (alignment: .center) {
                                Image(systemName: BookshelfViewModel.getReadImage(readStatus: statusArray[1]))
                                Text(statusArray[1])
                                
                                Spacer()
                                Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: statusArray[0]))
                                Text(statusArray[0])
                                
                            }.padding(.horizontal, 30)
                                .foregroundStyle(.navy)
                        }
                        LineView()
                    }
                    
                    VStack {
                        
                        if let desc = book.desc { // shows the description of the book
                            Text("Book Description")
                                .bold()
                                .padding(.vertical, 5)
                            Text(desc)
                                .frame(alignment: .center)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                    LineView()
                    
                    if (userViewModel.friends.count > 0) {
                        Text("Friends")
                            .bold()
                    }
                    VStack {
                        ForEach(userViewModel.friends) { friend in // iterates through friends
                            HStack {
                                if let array = userStatuses[friend.id] { // gets the status array for the friend
                                    Text(friend.displayName)
                                        .bold()
                                    Spacer()
                                    VStack (alignment: .trailing){
                                        Text(array[0]) // owner status
                                        Text(array[1]) // read status
                                    }
                                    VStack (alignment: .center){
                                        Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: array[0])) // shows image from bookshelf status
                                        Image(systemName: BookshelfViewModel.getReadImage(readStatus: array[1])) // shows image from read status
                                    }.padding(.trailing, 5)
                                }
                            }.padding(10)
                                .background(.lightPeach)
                                .frame(width: UIScreen.main.bounds.width - 20)
                                .cornerRadius(20)
                        }
                    }
                }
                
            }
        }.onAppear {
            getPercent()
            getCurrentUserStatuses()
            getFriendUserStatuses()
            userPageText = String(book.userPage ?? 0)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    userViewModel.shareSheet.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $userViewModel.shareSheet) {
            ShareView(
                book: book,
                userStatuses: userStatuses,
                userViewModel: userViewModel,
                chatViewModel: chatViewModel
            )
            //opens the share view in the sheet
        }
    }
    private func updateBookStatus(readStatus: String, bookshelf: String) {
        if let userPage = book.userPage, let pageCount = book.pageCount, let currentReadStatus = book.readStatus { // get variables
            if (userPage > 0 && userPage < pageCount && readStatus == "Reading") { // if the user is reading, and reading has been selected, stops pages read from being reset
            } else {
                let oldReadStatus = currentReadStatus
                book.readStatus = readStatus
                book.bookshelf = bookshelf
                userViewModel.updateStatus(book: book, oldReadStatus: oldReadStatus, readStatus: readStatus, ownerStatus: bookshelf) // updates status in firestore
                if (readStatus == "Reading" && oldReadStatus != "Reading") || readStatus == "Unread" {
                    book.userPage = 0
                    userPageText = "0" // sets local variables to 0
                }

                if readStatus == "Read" {
                    book.userPage = book.pageCount // sets the variable to page count
                }
            }
        }
    }
    
    private func getCurrentUserStatuses() { // gets the statuses of the current user for the shown book
        userViewModel.loadBooksFromFirestore(user: userViewModel.currentUser) { fetchedBooks in
            DispatchQueue.main.async {
                if let matchBook = fetchedBooks.first(where: { $0.id == book.id }), let readStatus = matchBook.readStatus, let ownerStatus = matchBook.bookshelf { // gets the book instance of the book in the users array
                    let array = [ownerStatus, readStatus] // gets the statuses of the book from the user
                    userStatuses[userViewModel.currentUser.id] = array
                    
                } else {
                    userStatuses[userViewModel.currentUser.id] = ["Not Owned", "--"] // sets the statuses to not owned, if it is not in the array
                }
            }
            bookshelfViewModel.getCurrentUserStatus()
            
        }
    }
    
    private func getFriendUserStatuses() { // gets the statuses of the friends for the shown book
        for user in userViewModel.friends { // iterates through each friend
            var books: [Book] = []
            userViewModel.loadBooksFromFirestore(user: user) { fetchedBooks in // gets the users books
                DispatchQueue.main.async {
                    books = fetchedBooks
                    if let matchBook = books.first(where: { $0.id == book.id }), let readStatus = matchBook.readStatus, let ownerStatus = matchBook.bookshelf { // gets the book instance of the book in the friends array
                        let array = [ownerStatus, readStatus] // gets the statuses of the book from the friend
                        userStatuses[user.id] = array
                        
                    } else {
                        userStatuses[user.id] = ["Not Owned", "--"] // sets the statuses to not owned, if it is not in the array
                    }
                }
            }
        }
    }
    
    private func updatePage(userPage: String) { // updates the user's page amount read
        if let page = Int(userPage) { // if the page number is a valid int
            userViewModel.updateUserPage(userPage: page, book: book)
            book.userPage = page
        }
    }
    
    private func checkValidInput() { // checks if the input is valid
        if let pageNumber = Int(userPageText) { // if the page number is an int
            if let pageCount = book.pageCount {
                if pageNumber >= 0 && pageNumber <= pageCount { // if the page number is within the range
                    validInput = true
                    return
                }
            }
        }
         validInput = false
    }
    
    
    private func checkFocus(focused: Bool) { // checks the focus, and ensures that the text is not null
        if (!focused) {
            if (userPageText.isEmpty) {
                userPageText = "0"
            }
        }
    }
    
    private func getPercent() { // calculates the percentage o=
        if let userPage = book.userPage, let pageCount = book.pageCount {
            if (pageCount != 0) {
                percentText = "\(userPage*100/pageCount)%"
            }
        }
    }
    
    private func checkIfRead() { // checks if the book has been finished based on the page count and amount the user has read
        if book.pageCount == book.userPage {
            if let bookshelf = book.bookshelf {
                updateBookStatus(readStatus: "Read", bookshelf: bookshelf)
                selectedReadStatus = "Read"
            }
        }
    }
}
