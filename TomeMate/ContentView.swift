//
//  ContentView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-01-28.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authManager: AuthManager
    @State private var path = NavigationPath()
    @State private var showLanding: Bool = true
 
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if showLanding {
                    SplashView(showLanding: $showLanding)
                } else if authManager.user != nil {
                    HomeView(path: $path)
                } else {
                    TomeAuthView()
                }
                
            }
            .navigationDestination(for: Character.self) { character in
                CharacterOverviewView(character: character, path: $path)
            }
            .navigationDestination(for: Campaign.self) { campaign in
                QuestLogView(campaign: campaign)
            }
        }
    }
}
#Preview {
    ContentView()
}
