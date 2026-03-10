//
//  HomeView.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//


import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        
        TabView {
<<<<<<< HEAD
=======
            CharactersDisplayView()
                .tabItem{
                    Label("Characters", systemImage: "person.fill")
                }
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
            SpellLookupView()
                .tabItem {
                    Label("Spell Lookup", systemImage: "book")
                }
            
            BestiaryLookupView()
                .tabItem {
                    Label("Bestiary Lookup", systemImage: "person.fill")
                }
            
            ItemLookupView()
                .tabItem {
                    Label("Item Lookup", systemImage: "calendar.badge.clock")
                }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
