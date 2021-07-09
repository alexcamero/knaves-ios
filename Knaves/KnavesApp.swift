//
//  KnavesApp.swift
//  Knaves
//
//  Created by The Captain on 3/24/21.
//

import SwiftUI
import Firebase

@main
struct KnavesApp: App {
    
//    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @ObservedObject var player: HumanPlayer = HumanPlayer()
    
    
    var body: some Scene {
        WindowGroup {
            ScreenIndex()
                .environmentObject(player)
        }
    }
}


//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    print("FirebaseApp configured")
//    return true
//  }
//}
