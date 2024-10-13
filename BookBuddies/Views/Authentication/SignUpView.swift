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
    @State var name: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel) // if the user is signed in, brings them to main view
        } else {
            VStack {
                Image("NameLong") // loads image from assets
                    .resizable()
                    .frame(width: 300, height: 60)
                    .padding(.bottom, 50)
                Text("Sign Up") // title
                    .font(.title)
                    .bold()
                
                TextField("Email", text: $username) // email field
                    .textFieldStyle(.roundedBorder)
                TextField("Display Name", text: $name) // name field
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password) // secure field for password
                    .textFieldStyle(.roundedBorder)
                SecureField("Confirm Password", text: $confirmPassword) // secure field for password confirmation
                    .textFieldStyle(.roundedBorder)
                
                Button("SIGN UP") {
                    if authViewModel.passwordsMatch(password: password, confirmPassword: confirmPassword) {
                        authViewModel.createAccount(withEmail: username, displayName: name, password: password)
                    } // checks the password matching, and creates an account if so
                }.buttonStyle(.borderedProminent)
                    .tint(.navy)
                    .padding(.vertical, 10)
                
                HStack {
                    Text("Have an account already?")
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel) // links to sign up view
                    } label: {
                        Text("Sign In!")
                    }.tint(.navy)
                }
          
                
                if let error = authViewModel.errorMessage { // error messages
                    ErrorView(errorMessage: error)
                }
            }.padding(.horizontal, 10)
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
}
