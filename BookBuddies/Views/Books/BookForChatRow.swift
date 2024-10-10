//
//  BookForChatRoqw.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 10/10/2024.
//

import SwiftUI

struct BookForChatRow: View {
    var bookshelfViewModel: BookshelfViewModel
    var chatViewModel: ChatViewModel
    @State var book: Book
    var source: String
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                if (source == "google") {
                    let authors = book.getAuthorStringFromJSON()
                    ZStack {
                        BookView(book: book, inSearch: true)
                            .frame(width: 70)
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .padding(.horizontal, 10)
                    }.frame(width: 100, height: 100)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(book.volumeInfo?.title ?? "") // book name
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .font(.system(size: 20))
                            .padding(.leading, 10)
                        
                        
                        Text(authors)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    ZStack {
                        BookView(book: book, inSearch: false)
                            .frame(width: 70)
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .padding(.horizontal, 10)
                    }.frame(width: 100, height: 100)
                    VStack (alignment: .leading) {
                        Text(book.title ?? "")
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .bold()
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(book.authors ?? "")
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                    Button {
                        if (source == "google") {
                            book = Book(id: book.id, title: book.getTitleFromJSON(), authors: book.getAuthorStringFromJSON(), bookshelf: "", image: book.getImageThumbnailFromJSON() ?? "", readStatus: "", desc: book.volumeInfo?.desc ?? "")
                        }
                        chatViewModel.book = book
                        chatViewModel.isShowingSheet = false
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.white, .navy)
                            .font(.system(size: 30))
                            .padding(10)
                    }
            }
            .frame(width: UIScreen.main.bounds.width - 20, height: 120, alignment: .leading)
            .background(.peach)
            .cornerRadius(6)
            .shadow(color: .black.opacity(0.33), radius: 1, x: 2, y: 2)
            .padding(.vertical, 2)
        }
    }
}
