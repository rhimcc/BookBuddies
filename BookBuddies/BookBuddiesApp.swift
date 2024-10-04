//
//  BookBuddiesApp.swift
//  BookBuddies
//
//  Created by Rhianna McCormack on 30/9/2024.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct BookBuddiesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(authViewModel: authViewModel)
            }
        }
        .modelContainer(for: Book.self)
    }
}
