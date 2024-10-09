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
    @State var chatId: String = ""
    @ObservedObject var chatViewModel: ChatViewModel = ChatViewModel()
    var body: some View {
        VStack {
            Text(friend.displayName)
            Spacer()
            ScrollViewReader { proxy in
            ScrollView {
                ForEach(chatViewModel.messages) { message in
                    MessageView(message: message, currentUserSender: message.senderId == User.getCurrentUser())
                }
            }.onAppear {
                chatViewModel.startListening(user1Id: User.getCurrentUser(), user2Id: friend.id) // Start listening to messages when the view appears
                if let lastMessage = chatViewModel.messages.last {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
            .onChange(of: chatViewModel.messages) { _ in
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
        
        
        HStack {
            TextField("Message...", text: $message)
                .textFieldStyle(.roundedBorder)
            Button {
                let newMessage = Message(id: UUID(), senderId: User.getCurrentUser(), receiverId: friend.id, messageContent: message, book: nil, time: Date().formatted(as: "YYYY-MM-dd HH:mm:ss"))
                userViewModel.storeMessage(user1: friend, user2: userViewModel.currentUser, message: newMessage)
                userViewModel.storeMessage(user1: userViewModel.currentUser, user2: friend, message: newMessage)
                message = ""
                
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 25.0).fill(.navy))
            }.disabled(message.isEmpty)
        }.padding(10)
    }
}

//#Preview {
//    ChatView()
//}
