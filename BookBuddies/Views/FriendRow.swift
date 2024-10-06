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
                if (!friendsList) {
                    if existingFriend {
                        Text("ADDED")
                        Image(systemName: "person.fill.checkmark")
                    } else {
                        Button {
                            userViewModel.addFriendToFirestore(user: friend)
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
}

//#Preview {
//    FriendRow(friend: User(id: "123", email: "nejnbe", displayName: "ABCD"), userViewModel: UserViewModel())
//}
