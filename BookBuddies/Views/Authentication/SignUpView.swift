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
            MainView(authViewModel: authViewModel)
        } else {
            VStack {
                Image("NameLong")
                    .resizable()
                    .frame(width: 300, height: 60)
                    .padding(.bottom, 50)
                Text("Sign Up")
                    .font(.title)
                    .bold()
                
                TextField("Email", text: $username)
                    .textFieldStyle(.roundedBorder)
                TextField("Display Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
                
                Button("SIGN UP") {
                    if authViewModel.passwordsMatch(password: password, confirmPassword: confirmPassword) {
                        authViewModel.createAccount(withEmail: username, displayName: name, password: password)
                    }
                }.buttonStyle(.borderedProminent)
                    .tint(.navy)
                    .padding(.vertical, 10)
                
                HStack {
                    Text("Have an account already?")
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel)
                    } label: {
                        Text("Sign In!")
                    }.tint(.navy)
                }
          
                
                if let error = authViewModel.errorMessage {
                    ErrorView(errorMessage: error)
                }
            }.padding(.horizontal, 10)
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
}
