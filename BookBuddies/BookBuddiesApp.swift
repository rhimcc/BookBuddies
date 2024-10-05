//
//  BookBuddiesApp.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  var authViewModel: AuthViewModel?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    let db = Firestore.firestore()
    authViewModel = AuthViewModel()
    
    return true
  }
}

@main
struct BookBuddiesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if let authViewModel = delegate.authViewModel {
                NavigationView {
                    ContentView(authViewModel: authViewModel)
                }
            } else {
                Text("Loading...") // Show a loading state while Firebase is initializing
            }
        }
        .modelContainer(for: Book.self)
    }
}

