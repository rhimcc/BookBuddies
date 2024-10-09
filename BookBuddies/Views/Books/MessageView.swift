//
//  MessageView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 9/10/2024.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    @State var currentUserSender: Bool
    var body: some View {
        HStack {
            if (currentUserSender) {
                Spacer()
            }
            Text(message.messageContent)
                .padding(10)
                .background(currentUserSender ? .navy : .lightPeach)
                .cornerRadius(20)
                .foregroundStyle(currentUserSender ? .lightPeach : .navy)
                .padding(10)
                .frame(maxWidth: .infinity, alignment: currentUserSender ? .trailing : .leading) // Fill width
            
            if (currentUserSender) {
                Spacer()
            }
        }.padding(currentUserSender ? .leading : .trailing, 30) // Add padding to create space on the side
        .padding(.vertical, 5)
    }
}
//
//#Preview {
//    MessageView()
//}
