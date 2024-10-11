//
//  ShareToFriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 11/10/2024.
//

import SwiftUI
struct ShareToFriendView: View {
    var friend: User
    var userStatuses: [String: [String]]
    var userViewModel: UserViewModel
    var book: Book
    
    var body: some View {
        HStack {
            Text(friend.displayName)
            Spacer()
            if let array = userStatuses[friend.id] {
                HStack {
                    VStack {
                        Text(array[0])
                        Text(array[1])
                    }
                    VStack {
                        Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: array[0]))
                        Image(systemName: BookshelfViewModel.getReadImage(readStatus: array[1]))
                    }
                }.frame(alignment: .trailing)
            }
            NavigationLink {
                var chatViewModel: ChatViewModel = ChatViewModel()
                ChatView(userViewModel: userViewModel, friend: friend, chatViewModel: chatViewModel)
                    .onAppear {
                        chatViewModel.book = book
                        
                    }
            } label : {
                ZStack {
                    Rectangle()
                        .fill(.navy)
                        .frame(width: 40, height: 40)
                        .cornerRadius(5)
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.lightPeach)
                .frame(width: UIScreen.main.bounds.width - 20)
        )
    }
}
//}
//struct ShareToFriendView: View {
//    var friend: User
//    var userStatuses: [String: [String]]
//    var userViewModel: UserViewModel
//    var book: Book
//    var chatViewModel: ChatViewModel = ChatViewModel()
//    @State private var navigateToChatView: Bool = false // State to control navigation
//    @Environment(\.dismiss) var dismiss // For closing the current view
//
//    var body: some View {
//        NavigationStack {
//            HStack {
//                Text(friend.displayName)
//                Spacer()
//                if let array = userStatuses[friend.id] {
//                    HStack {
//                        VStack {
//                            Text(array[0])
//                            Text(array[1])
//                        }
//                        VStack {
//                            Image(systemName: BookshelfViewModel.getBookshelfImage(bookshelf: array[0]))
//                            Image(systemName: BookshelfViewModel.getReadImage(readStatus: array[1]))
//                        }.frame(alignment: .trailing)
//                    }.frame(alignment: .trailing)
//                    
//                }
//                NavigationLink(destination: ChatView(userViewModel: userViewModel, friend: friend), isActive: $navigateToChatView) {
//                    EmptyView()
//                }
//                
//                Button {
//                    chatViewModel.book = book  // Set the book in chatViewModel
//                    navigateToChatView = true  // Trigger navigation
////                    dismiss()  // Dismiss the current view
//                } label: {
//                    ZStack {
//                        Rectangle()
//                            .fill(.navy)
//                            .frame(width: 40, height: 40)
//                            .cornerRadius(5)
//                        Image(systemName: "paperplane.fill")
//                            .foregroundStyle(.white)
//                    }
//                }
////                Button {
////                    
////                } label : {
////                    ZStack {
////                        Rectangle()
////                            .fill(.navy)
////                            .frame(width: 40, height: 40)
////                            .cornerRadius(5)
////                        Image(systemName: "paperplane.fill")
////                            .foregroundStyle(.white)
////                    }
////                }
//            }.padding(10)
//                .background(RoundedRectangle(cornerRadius: 15).fill(.lightPeach).frame(width: UIScreen.main.bounds.width - 20))
//            
//        }
//    }
//}


//#Preview {
//    ShareToFriendView(friend: User(id: "123", email: "", displayName: "", status: ""), userStatuses: ["123": ["Owned", "Read"]], userViewModel: UserViewModel(), book: Book(id: "123", title: "gwr", authors: "wegrgwg", bookshelf: "", image: "wiokfv", readStatus: "efwio", desc: "fnwjkenjkrgw"))
//}
