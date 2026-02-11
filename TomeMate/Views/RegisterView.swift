//
//  RegisterView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String?
    @State private var glowPulse = false

    var body: some View {
        ZStack {
            ArcaneTheme.background
                .ignoresSafeArea()
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.7)
                ]),
                center: .center,
                startRadius: 100,
                endRadius: 600
            )
            .ignoresSafeArea()
            ArcaneParticlesView()
            ArcaneCard {
                VStack(spacing: 24) {
                            
                    Text("First time, adventurer?")
                        .font(.custom("Cinzel-Bold", size: 30))
                        .foregroundStyle(.white)
                        .shadow(color: ArcaneTheme.glow,
                            radius: glowPulse ? 25 : 8)
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                            ) {
                                glowPulse.toggle()
                            }
                        }
                            
                    ArcaneTextField(title: "Email", text: $email)
                    ArcaneTextField(title: "Password", text: $password, isSecure: true)
                            
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                            
                    Button {
                        authManager.register(email: email, password: password) { result in
                            switch result {
                            case .success:
                                print("Successful registration")
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Begin Your Journey")
                            .fontWeight(.bold)
                    }
                    .arcaneButton()
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
