//
//  FriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 5/10/2024.
//

import SwiftUI

struct FriendView: View {
    @State var users: [User] = []
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Friends")
                    .font(.title)
                    .bold()
                Spacer()
                NavigationLink {
                    AddFriendView(userViewModel: userViewModel)
                } label : {
                    ZStack {
                        Circle()
                            .fill(.navy)
                            .frame(width: 30, height: 30)
                        Text("+")
                            .foregroundStyle(.white)
                            .font(.system(size: 20))
                    }
                }
                
            }
            
            ForEach(users) { user in // Use the users array directly
                if (user.id != User.getCurrentUser()) {
                    HStack {
                        Text(user.displayName)
                        Button("ADD friend") {
                            userViewModel.addFriendToFirestore(user: user)
                            print("Adding friend: \(user.displayName)") // Debug print to ensure button action is triggered
                            //                        Friend.addFriendToFirestore(user)
                        }
                    }
                }
            }
        }.onAppear {
           loadUsers()
        }
    }
    
    func loadUsers() {
        UserViewModel.loadUsers() { users in
            DispatchQueue.main.async {
                self.users = users
            }
        }
    }
}


//#Preview {
//    FriendView()
//}
