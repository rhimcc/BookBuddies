//
//  StartView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 5/10/2024.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()

    var body: some View {
        Image("NameShort")
            .resizable()
            .frame(width: 300, height: 225)
            .padding(.bottom, 150)
        HStack {
            NavigationLink {
                SignInView(authViewModel: authViewModel)
            } label: {
                Text("SIGN IN")
                    .bold()
            }.buttonStyle(.borderedProminent)
                .tint(.navy)
                .padding(5)
            NavigationLink {
                SignUpView(authViewModel: authViewModel)
            } label: {
                Text("SIGN UP")
                    .bold()
            }.buttonStyle(.borderedProminent)
                .tint(.navy)
                .padding(5)

        }
    }
}

#Preview {
    StartView(authViewModel: AuthViewModel())
}
