//
//  ArcaneTextField.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//

import SwiftUI

struct ArcaneTextField: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false // for SecureFields (pwd)
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text, prompt: Text("Enter your password").foregroundStyle(.black))
            } else {
                TextField(title, text: $text, prompt: Text("Enter your email").foregroundStyle(.black))
                    .autocapitalization(.none)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.06),
                    Color.purple.opacity(0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ArcaneTheme.glow.opacity(0.6), lineWidth: 1)
        )
        .cornerRadius(14)
        .shadow(color: ArcaneTheme.glow.opacity(0.4), radius: 10)
    }
}
