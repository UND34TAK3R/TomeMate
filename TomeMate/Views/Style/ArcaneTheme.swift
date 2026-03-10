//
//  ArcaneTheme.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-02-10.
//
import SwiftUI

struct ArcaneTheme {
    static let background = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.02, blue: 0.10),
            Color(red: 0.18, green: 0.08, blue: 0.35),
            Color(red: 0.05, green: 0.00, blue: 0.15)
        ],
        startPoint: .topLeading,
        endPoint: .trailing
    )
    
    static let primary = Color.purple
    static let accent = Color.blue
    static let glow = Color.purple.opacity(0.7)
}
