//
//  FriendView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 5/10/2024.
//

import SwiftUI

struct FriendView: View {
    @State var friends: [User] = []
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
            Spacer()
            ForEach(friends) { friend in
                FriendRow(friend: friend, userViewModel: userViewModel, friendsList: true)
            }
        }.onAppear {
            loadFriends()
        }
    }
    
    func loadFriends() {
        UserViewModel.loadFriends() { users in
            DispatchQueue.main.async {
                self.friends = users
            }
        }
    }
}


//#Preview {
//    FriendView()
//}
