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
                VStack (alignment: currentUserSender ? .trailing : .leading){
                    Text(String(message.time[message.time.index(message.time.startIndex, offsetBy: 11)...message.time.index(message.time.startIndex, offsetBy: 15)]))
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .frame(alignment: currentUserSender ? .trailing : .leading)
                    Text(message.messageContent)
                        .padding(10)
                        .background(currentUserSender ? .navy : .lightPeach)
                        .cornerRadius(20)
                        .foregroundStyle(currentUserSender ? .veryLightPeach : .navy)
                        .frame(maxWidth: .infinity, alignment: currentUserSender ? .trailing : .leading) // Fill width
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
