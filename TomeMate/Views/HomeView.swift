//
//  HomeView.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        TabView {
            CharactersDisplayView(path: $path)
                .tabItem {
                    Label("Characters", systemImage: "person.fill")
                }

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
    // HomeView()
    //     .environmentObject(AuthManager())
}
