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
        if (authViewModel.isSignedIn) {
            MainView(authViewModel: authViewModel)
        } else {
            VStack {
                Image("NameLong")
                    .resizable()
                    .frame(width: 300, height: 60)
                    .padding(.bottom, 50)
                Text("Sign In")
                    .font(.title)
                    .bold()
                TextField("Email", text: $username)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                Button("SIGN IN") {
                    authViewModel.signIn(withEmail: username, password: password)
                }.buttonStyle(.borderedProminent)
                    .tint(.navy)
                    .padding(.vertical, 10)
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink {
                        SignUpView(authViewModel: authViewModel)
                    } label: {
                        Text("Sign Up!")
                    }.tint(.navy)
                }
                
                
                if let error = authViewModel.errorMessage {
                    Text(error)
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
