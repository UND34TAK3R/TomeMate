//
//  ArcaneParticlesView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//

import SwiftUI

struct ArcaneParticlesView: View {
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<12) { _ in
                    Image(systemName: "sparkle")
                        .font(.system(size: CGFloat.random(in: 15...40)))
                        .foregroundColor(ArcaneTheme.primary.opacity(0.4))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                        .opacity(animate ? 0.8 : 0.2)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...5))
                                .repeatForever(autoreverses: true),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
        .allowsHitTesting(false)
    }
}
