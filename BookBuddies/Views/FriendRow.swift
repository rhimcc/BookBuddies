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
            }
            Spacer()
            HStack {
                if (friendsList) {
                    if (friend.status == "Pending") {
                        Button {
                            userViewModel.approveFriend(friend: friend)
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .padding(.trailing, 10)
                        }
                        Button {
                            userViewModel.removeFriendFromFirestore(friend: friend, from: userViewModel.currentUser)
                            userViewModel.friends.remove(at: getIndex(of: friend))
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .font(.system(size: 30))
                        }
                    } else {
                        NavigationLink {
                            Bookshelf(bookshelfViewModel: BookshelfViewModel(), bookshelfOwner: friend, userViewModel: userViewModel)
                        } label: {
                            Image("BookshelfNavy")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        }.padding(.trailing, 10)
                        
                        NavigationLink {
                            ChatView(userViewModel: userViewModel, friend: friend)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.navy)
                                Image(systemName: "message")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                            }.frame(width: 45, height: 45)
                        }
                        
                        Button {
                            userViewModel.friends.remove(at: getIndex(of: friend))
                            userViewModel.removeFriendFromFirestore(friend: friend, from: userViewModel.currentUser)
                            userViewModel.removeFriendFromFirestore(friend: userViewModel.currentUser, from: friend)

//                            self.existingFriend.toggle()
                            
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.navy)
                                   
                                Image(systemName: "person.badge.minus")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.white)
                            } .frame(width: 45, height: 45)
                            
                        }
                    }
                }
                if (!friendsList) {
                    if existingFriend {
                        Text("FRIENDS")
                            .bold()
                        Image(systemName: getIcon(status: "Friends"))

                    } else if pendingFriend {
                        Text("PENDING")
                            .bold()
                        Image(systemName: getIcon(status: "Pending"))
                        Button {
                            userViewModel.removeFriendFromFirestore(friend: userViewModel.currentUser, from: friend)
                            pendingFriend.toggle()
                        } label : {
                            Image(systemName: "xmark")
                        }
                    } else {
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
    
    func checkIfFriend() {
        userViewModel.isFriend(user: friend) { isFriend in
            self.existingFriend = isFriend
            userViewModel.hasPendingRequest(from: userViewModel.currentUser, to: friend) { hasPendingRequest in
                if hasPendingRequest {
                    self.pendingFriend = true
                }
            }
        }
    }
    
    func getIndex(of user: User) -> Int {
        for i in userViewModel.friends.indices {
            if userViewModel.friends[i].id == user.id {
                return i
            }
            
        }
        return 0
    }
    
    func getIcon(status: String) -> String {
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
