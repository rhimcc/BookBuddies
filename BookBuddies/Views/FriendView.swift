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
        NavigationStack {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Text("Friends")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    HStack (alignment: .center) {
                        Spacer()
                        NavigationLink {
                            AddFriendView(userViewModel: userViewModel)
                        } label : {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.navy)
                                .font(.system(size: 40))
                        }
                    }.padding(.horizontal, 10)
                }
                
                ScrollView {
                    Text("Pending")
                    ForEach(userViewModel.friends.filter {$0.status == "Pending"}) { friend in
                        FriendRow(friend: friend, userViewModel: userViewModel, friendsList: true)
                    }
                    Text("Friends")
                    ForEach(userViewModel.friends.filter {$0.status == "Approved"}) { friend in
                        FriendRow(friend: friend, userViewModel: userViewModel, friendsList: true)
                    }
                }
            }
        }
    }
    
}


//#Preview {
//    FriendView()
//}
