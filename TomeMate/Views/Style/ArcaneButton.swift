//
//  ArcaneButton.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//

import SwiftUI

extension View {
    func arcaneButton() -> some View {
        self
            .font(.system(size: 18, weight: .bold, design: .serif))
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                ZStack {
                    LinearGradient(
                        colors: [ArcaneTheme.primary,ArcaneTheme.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                }
            )
            .cornerRadius(16)
            .foregroundStyle(.white)
            .shadow(color: ArcaneTheme.glow, radius: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ArcaneTheme.glow.opacity(0.6), lineWidth: 1)
                    .blur(radius: 4)
            )
    }
}
