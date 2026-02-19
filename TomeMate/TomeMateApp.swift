//
//  TomeMateApp.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-01-28.
//

import SwiftUI
import CoreData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct TomeMateApp: App {

    @StateObject private var authManager = AuthManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        let context = persistenceController.container.viewContext
        let dateHolder = DateHolder(context)
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
                .environmentObject(authManager)
        }
    }
}
