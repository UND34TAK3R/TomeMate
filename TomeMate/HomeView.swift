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
        VStack{
            Text("Welcome, \(authManager.user?.email ?? "User")")
                .font(.title)
                .padding()
            
            Button{
                authManager.signOut()
            } label: {
                Text("Logout")
                    .foregroundStyle(.white)
                    .background(.red)
                    .padding()
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
