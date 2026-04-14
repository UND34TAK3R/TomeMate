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
    @State private var showSignOutConfirmation = false

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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSignOutConfirmation = true
                } label: {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(.tomeGold)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .confirmationDialog(
            "Leave the Tome?",
            isPresented: $showSignOutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Sign Out", role: .destructive) {
                authManager.signOut()
            }
            Button("Stay", role: .cancel) {}
        } message: {
            Text("Your adventure will be waiting when you return.")
        }
    }
}

#Preview {
    // HomeView()
    //     .environmentObject(AuthManager())
}
