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
                ForEach(userViewModel.friends) { friend in
                    FriendRow(friend: friend, userViewModel: userViewModel, friendsList: true)
                }
            }
        }
    }
    
}


//#Preview {
//    FriendView()
//}
