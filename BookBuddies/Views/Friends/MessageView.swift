//
//  MessageView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    var message: Message
    @State var currentUserSender: Bool
    var body: some View {
            
            HStack {
                if (currentUserSender) { // makes bubble align right is the user is the sender
                    Spacer()
                }
                VStack (alignment: currentUserSender ? .trailing : .leading){
                   
                    // time text
                    Text(String(message.time[message.time.index(message.time.startIndex, offsetBy: 11)...message.time.index(message.time.startIndex, offsetBy: 15)]))
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .frame(alignment: currentUserSender ? .trailing : .leading)
                    
                    VStack {
                        // if there is a book in the message, provide link to its detail with a preview
                        if let book = message.book {
                            NavigationLink {
                                BookDetail(book: book, bookshelfViewModel: BookshelfViewModel(), userViewModel: userViewModel, source: "other")
                            } label : {
                                VStack {
                                    BookView(book: book, inSearch: false)
                                        .frame(height: 100)
                                        .aspectRatio(contentMode: .fit)
                                    if let title = book.title {
                                        Text(title)
                                            .foregroundStyle(currentUserSender ? .navy : .veryLightPeach)
                                            .underline()
                                            .bold()
                                            .padding(.bottom, 5)
                                            .padding(.horizontal, 5)
                                    }
                                }.background(currentUserSender ? .veryLightPeach : .navy)
                                .cornerRadius(5)
                            }
                        }
                            
                        Text(message.messageContent)
                            .foregroundStyle(currentUserSender ? .veryLightPeach : .navy) // set colours based on reader/sender
                            .frame(alignment: currentUserSender ? .trailing : .leading) // set alignment based on reader/sender
                    }.padding()
                    .background(currentUserSender ? .navy : .lightPeach) // set colours based on reader/sender
                    .cornerRadius(20)
                }
                .frame(maxWidth: 250, alignment: currentUserSender ? .trailing : .leading)
                
                if (!currentUserSender) { // makes bubble align left is the user is not the sender
                    Spacer()
                }
            }.padding(.horizontal, 10)
                .padding(.bottom, 5)
        
    }
}
//
//#Preview {
//    MessageView()
//}
