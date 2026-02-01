//
//  TomeMateApp.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-01-28.
//

import SwiftUI
import CoreData

@main
struct TomeMateApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        let context = persistenceController.container.viewContext
        let dateHolder = DateHolder(context)
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dateHolder)
        }
    }
}
