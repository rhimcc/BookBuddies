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
                if (currentUserSender) {
                    Spacer()
                }
                VStack (alignment: currentUserSender ? .trailing : .leading){
                   
                    Text(String(message.time[message.time.index(message.time.startIndex, offsetBy: 11)...message.time.index(message.time.startIndex, offsetBy: 15)]))
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .frame(alignment: currentUserSender ? .trailing : .leading)
                    VStack {
                        if let book = message.book {
                            NavigationLink {
                                BookDetail(book: book, bookshelfViewModel: BookshelfViewModel(), userViewModel: userViewModel)
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
                            .cornerRadius(20)
                            .foregroundStyle(currentUserSender ? .veryLightPeach : .navy)
                            .frame(alignment: currentUserSender ? .trailing : .leading)
                    }.padding()
                    .background(currentUserSender ? .navy : .lightPeach)
                    .cornerRadius(20)
                }
                .frame(maxWidth: 250, alignment: currentUserSender ? .trailing : .leading) // Constrain message width
                
                if (!currentUserSender) {
                    Spacer()
                }
            }.padding(.horizontal, 10) // Add padding to create space on the side
                .padding(.bottom, 5)
        
    }
}
//
//#Preview {
//    MessageView()
//}
