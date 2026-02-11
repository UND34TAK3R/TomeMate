//
//  LoginView.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//

import SwiftUI

struct LoginView: View {
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
                    Text("Welcome back, adventurer!")
                        .font(.custom("Cinzel-Bold", size: 30))
                            .foregroundColor(.white)
                            .shadow(color: ArcaneTheme.glow,
                                    radius: glowPulse ? 20 : 6)
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

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button {
                        authManager.login(email: email, password: password) {
                            result in
                            switch result {
                            case .success:
                                print("Successful login")
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Login")
                            .fontWeight(.bold)
                    }
                    .arcaneButton()
                }
            }
        }
    }
}
#Preview {
    LoginView()
}
