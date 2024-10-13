//
//  ChatView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import SwiftUI

struct ChatView: View {
    var userViewModel: UserViewModel
    var friend: User
    @State var message: String = ""
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var searchViewModel: BookSearchViewModel = BookSearchViewModel()
    @State var bookTitle: String = ""
    @State var books: [Book] = []
    @State var newMessage: Message? = nil
    var body: some View {
        VStack {
            Text(friend.displayName)
                .font(.title)
            Spacer()
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatViewModel.messages) { message in // show all messages
                        MessageView(message: message, currentUserSender: message.senderId == User.getCurrentUser())
                    }
                }.onAppear {
                    chatViewModel.startListening(user1Id: User.getCurrentUser(), user2Id: friend.id)
                   
                    if let lastMessage = chatViewModel.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    } // snaps the view to the last sent message
                    chatViewModel.currentUser = userViewModel.currentUser
                    chatViewModel.friend = friend
                    chatViewModel.loadCurrentUser()
                    chatViewModel.loadOtherUser()
                }
                .onChange(of: chatViewModel.messages) { _, _ in // snaps view to the last sent message
                    if let lastMessage = chatViewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }.onDisappear {
                chatViewModel.stopListening() // Stop listening when the view disappears
            }
        }
        
        VStack {
            if let book = chatViewModel.book {
                HStack {
                    BookView(book: book, inSearch: false) // show cover
                        .frame(height: 25)
                        .aspectRatio(contentMode: .fit)
                    
                    Text(book.title ?? "")
                        .foregroundStyle(.veryLightPeach)
                        .bold()
                        .lineLimit(1) // Limit to one line
                        .truncationMode(.tail) // Use tail truncation
                        .fixedSize(horizontal: false, vertical: true) // Prevent stretching
                    Spacer()
                    Button {
                        chatViewModel.book = nil
                    } label : {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }.padding(.trailing, 10)
                }.background(RoundedRectangle(cornerRadius: 20)
                    .fill(Color.navy)
                    .frame(height: 40)
                    )
                .frame(height: 40)
            }
        
            HStack {
                TextField("Message...", text: $message, axis: .vertical) // message field
                .textFieldStyle(.roundedBorder)
                .lineLimit(20)
                
                Button {
                    chatViewModel.isShowingSheet = true
                } label : {
                    Image(systemName: "book")
                        .foregroundStyle(.navy)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 25.0).fill(.lightPeach))
                }
                Button {
                    if let book = chatViewModel.book { // if there is a book attached
                        newMessage = Message(id: UUID(), senderId: User.getCurrentUser(), receiverId: friend.id, messageContent: message, book: book, time: Date().formatted(as: "YYYY-MM-dd HH:mm:ss"))
                    } else { // if there is no book attached
                        newMessage = Message(id: UUID(), senderId: User.getCurrentUser(), receiverId: friend.id, messageContent: message, book: nil, time: Date().formatted(as: "YYYY-MM-dd HH:mm:ss"))
                    }
                    if let message = newMessage { // stores the message in both users fire store
                        userViewModel.storeMessage(user1: friend, user2: userViewModel.currentUser, message: message)
                        userViewModel.storeMessage(user1: userViewModel.currentUser, user2: friend, message: message)
                    }
                    message = ""
                    chatViewModel.book = nil
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    
                        .background(RoundedRectangle(cornerRadius: 25.0).fill(.navy))
                }.disabled(message.isEmpty)
            }
            
            
        }.padding(10)
            .sheet(isPresented: $chatViewModel.isShowingSheet,
                   onDismiss: dismiss) {
                BookSearchView(chatViewModel: chatViewModel, currentUser: userViewModel.currentUser, friend: friend)
            }
               
    }
    
    func dismiss() {
        chatViewModel.isShowingSheet = false
    }
    
}

//#Preview {
//    ChatView()
//}
