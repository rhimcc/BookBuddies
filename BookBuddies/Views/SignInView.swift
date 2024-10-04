//
//  SignInView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 4/10/2024.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel)
        } else {
            VStack {
                Text("Sign In")
                    .font(.title)
                TextField("Email", text: $username)
                SecureField("Password", text: $password)
                Button("SIGN IN") {
                    authViewModel.signIn(withEmail: username, password: password)
                }.buttonStyle(.borderedProminent)
                NavigationLink {
                    SignUpView(authViewModel: authViewModel)
                } label: {
                    Text("SIGN UP")
                        .buttonStyle(.borderedProminent)
                }
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                }
            }.onAppear {
                username = ""
                password = ""
            }
        }
    }
}

//#Preview {
//    SignInView()
//}
