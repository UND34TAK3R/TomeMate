//
//  SpellLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct SpellLookupView: View {
    @State private var errorMessage: String?
    @StateObject private var viewModel = SpellLookupViewModel()
    
    var body: some View {
        ZStack {
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()
            
            VStack {
                
                ArcaneTextField(title: "Search Spell", text: $viewModel.searchText)
                
                List(viewModel.spells) { spell in
                    VStack(alignment: .leading) {
                        Text(spell.name)
                            .font(.headline)
                        Text(spell.description)
                            .font(.caption)
                            .lineLimit(3)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Spells")
    }
}

#Preview {
    SpellLookupView()
}
