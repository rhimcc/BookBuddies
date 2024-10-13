import SwiftUI

struct FriendRow: View {
    @State var friend: User
    @ObservedObject var userViewModel: UserViewModel
    @State var existingFriend: Bool = false
    @State var friendsList: Bool
    @State var pendingFriend: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(friend.displayName)
                    .bold()
                Text(friend.id)
                    .italic()
                    .font(.system(size: 15))
            }
            Spacer()
            HStack {
                if (friendsList) {
                    if (friend.status == "Pending") { // if the friend is pending
                        Button {
                            userViewModel.approveFriend(friend: friend) // approve friend button
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .padding(.trailing, 10)
                        }
                        Button {
                            userViewModel.removeFriendFromFirestore(friend: friend, from: userViewModel.currentUser) // reject friend button
                            userViewModel.friends.remove(at: getIndex(of: friend))
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .font(.system(size: 30))
                        }
                    } else { // friend is friend, not pending
                        NavigationLink {
                            Bookshelf(bookshelfViewModel: BookshelfViewModel(), bookshelfOwner: friend, userViewModel: userViewModel) // view friends bookshelf
                        } label: {
                            Image("BookshelfNavy")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                        }
                        
                        NavigationLink {
                            ChatView(userViewModel: userViewModel, friend: friend, chatViewModel: ChatViewModel()) // open chat with friend
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.navy)
                                Image(systemName: "message")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                            }.frame(width: 35, height: 35)
                        }
                        
                        Button {
                            userViewModel.friends.remove(at: getIndex(of: friend)) // delete friend
                            userViewModel.removeFriendFromFirestore(friend: friend, from: userViewModel.currentUser)
                            userViewModel.removeFriendFromFirestore(friend: userViewModel.currentUser, from: friend) // remove from both users in firestore
                            
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.navy)
                                   
                                Image(systemName: "person.badge.minus")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                            } .frame(width: 35, height: 35)
                            
                        }
                    }
                }
                if (!friendsList) { // if the view is not in the friends list
                    if existingFriend { // if the users are already friends
                        Text("FRIENDS")
                            .bold()
                        Image(systemName: getIcon(status: "Friends"))

                    } else if pendingFriend { // if the user is pending
                        Text("PENDING")
                            .bold()
                        Image(systemName: getIcon(status: "Pending"))
                        Button {
                            userViewModel.removeFriendFromFirestore(friend: userViewModel.currentUser, from: friend)
                            pendingFriend.toggle()
                        } label : {
                            Image(systemName: "xmark")
                        }
                    } else { // if the users aren't friends, and it is not pending
                        Button {
                            userViewModel.addFriendToFirestore(friend: userViewModel.currentUser, to: friend, status: "Pending")
                            userViewModel.friends.append(friend)
                            self.pendingFriend.toggle()
                        } label : {
                            Text("ADD")
                            Image(systemName: "person.fill.badge.plus")
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundStyle(.white)
                    }
                }
            }.tint(.navy)
                
        }.padding(15)
        .frame(width: UIScreen.main.bounds.width - 40, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.peach)
            
        )
        .onAppear {
            checkIfFriend()
        }
    }
    
    func checkIfFriend() { // checks if the users are friends
        userViewModel.isFriend(user: friend) { isFriend in
            self.existingFriend = isFriend
            userViewModel.hasPendingRequest(from: userViewModel.currentUser, to: friend) { hasPendingRequest in
                if hasPendingRequest {
                    self.pendingFriend = true
                }
            }
        }
    }
    
    func getIndex(of user: User) -> Int { // gets the index of a user within the friends list
        for i in userViewModel.friends.indices {
            if userViewModel.friends[i].id == user.id {
                return i
            }
            
        }
        return 0
    }
    
    func getIcon(status: String) -> String { // gets the icon for pending/friend/not friend status
        switch(status) {
        case "Pending":
            return "person.badge.clock.fill"
            
        case "Friends":
            return "person.2.fill"
        
        default:
            return "person.badge.plus.fill"
        }
    }
}

//#Preview {
//    FriendRow(friend: User(id: "123", email: "huijdvs", displayName: "gfewhuijc", status: ""), userViewModel: UserViewModel(), friendsList: false)
//}
