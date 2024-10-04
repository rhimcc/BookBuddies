//
//  SignUpView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 4/10/2024.
//

import SwiftUI

struct SignUpView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel)
        } else {
            VStack {
                Text("Sign Up")
                    .font(.title)
                TextField("Email", text: $username)
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmPassword)
                Button("SIGN UP") {
                    if authViewModel.passwordsMatch(password: password, confirmPassword: confirmPassword) {
                        authViewModel.createAccount(withEmail: username, password: password)
                    }
                }.buttonStyle(.borderedProminent)
                if let error = authViewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

//#Preview {
//    SignUpView()
//}
