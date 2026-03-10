//
//  SpellLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct SpellLookupView: View {
<<<<<<< HEAD
    @State private var errorMessage: String?
    @StateObject private var viewModel = SpellLookupViewModel()
    
=======
    @StateObject private var viewModel = SpellLookupViewModel()

>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
    var body: some View {
        ZStack {
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()
<<<<<<< HEAD
            
            VStack {
                
                ArcaneTextField(title: "Search Spell", text: $viewModel.searchText)
                
                List(viewModel.spells) { spell in
                    VStack(alignment: .leading) {
                        Text(spell.name)
                            .font(.headline)
                        Text(spell.description)
                            .font(.caption)
                            .lineLimit(3)
=======

            VStack {
                TextField("", text: $viewModel.searchText, prompt: Text("Search Spell").foregroundColor(.black))
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
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
                List {
                    ForEach(viewModel.spells) { spell in
                        VStack(alignment: .leading) {
                            Text(spell.name)
                                .font(.headline)
                            Text(spell.description)
                                .font(.caption)
                                .lineLimit(3)
                        }
                    }

                    // Pagination trigger at bottom of list
                    if viewModel.hasMorePages {
                        HStack {
                            Spacer()
                            ProgressView()
                                .onAppear { viewModel.fetchSpells() }
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
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
