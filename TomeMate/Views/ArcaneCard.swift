//
//  ArcaneCard.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//

import SwiftUI

struct ArcaneCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.purple.opacity(0.25)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.8),
                                    Color.blue.opacity(0.8)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: ArcaneTheme.glow, radius: 25)
            
            content
                .padding(30)
        }
        .padding(.horizontal, 24)
    }
}

//#Preview {
//    ArcaneCard()
//}
