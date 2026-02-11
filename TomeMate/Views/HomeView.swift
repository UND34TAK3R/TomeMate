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
        Group {
            if authManager.user != nil {
                Text("Welcome user!")
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
