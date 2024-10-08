import SwiftUI

struct FriendRow: View {
    @State var friend: User
    @ObservedObject var userViewModel: UserViewModel
    @State var existingFriend: Bool = false
    @State var friendsList: Bool
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
                    NavigationLink {
                        Bookshelf(bookshelfViewModel: BookshelfViewModel(), bookshelfOwner: friend)
                    } label: {
                        Image("BookshelfNavy")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    
                    Button {
                        userViewModel.friends.remove(at: getIndex(of: friend))
                        userViewModel.removeFriendFromFirestore(user: friend)
                        self.existingFriend.toggle()

                    } label: {
                        Text("Remove")
                        Image(systemName: "person.badge.minus")
                    }
                }
                if (!friendsList) {
                    if existingFriend {
                        Text("ADDED")
                        Image(systemName: "person.fill.checkmark")
                    } else {
                        Button {
                            userViewModel.addFriendToFirestore(user: friend)
                            userViewModel.friends.append(friend)
                            self.existingFriend.toggle()
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
            existingFriend = isFriend
        }
    }
    
    func getIndex(of user: User) -> Int {
        for i in userViewModel.friends.indices {
            print(i)
            if userViewModel.friends[i].id == user.id {
                return i
            }
            
        }
        return 0
    }
}
