//
//  SignInView.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 4/10/2024.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @StateObject var authViewModel: AuthViewModel
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        if (authViewModel.isSignedIn) { // if the user is signed in, puts them in the main view
            MainView(authViewModel: authViewModel)
        } else {
            VStack {
                Image("NameLong") // loads image from assets
                    .resizable()
                    .frame(width: 300, height: 60)
                    .padding(.bottom, 50)
                Text("Sign In")
                    .font(.title)
                    .bold()
                TextField("Email", text: $username) // email field
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password) // secure field for password
                    .textFieldStyle(.roundedBorder)
                Button("SIGN IN") { // sign in button
                    authViewModel.signIn(withEmail: username, password: password)
                }.buttonStyle(.borderedProminent)
                    .tint(.navy)
                    .padding(.vertical, 10)
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel) // link to sign up view
                    } label: {
                        Text("Sign Up!")
                    }.tint(.navy)
                }
                
                
                if let error = authViewModel.errorMessage {
                    ErrorView(errorMessage: error)
                }
            }.padding(.horizontal, 10)
            .onAppear {
                username = ""
                password = ""
            }
        }
    }
}

#Preview {
    SignInView(authViewModel: AuthViewModel())
}
