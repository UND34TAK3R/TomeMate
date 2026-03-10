//
//  BestiaryLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct BestiaryLookupView: View {
<<<<<<< HEAD
    
    
    @StateObject private var viewModel = BestiaryLookupViewModel()
    
=======
    @StateObject private var viewModel = BestiaryLookupViewModel()

>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
    var body: some View {
        ZStack {
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()
<<<<<<< HEAD
            
            VStack {
                
                ArcaneTextField(title: "Search Item", text: $viewModel.searchText)
                
                Button("Search") {
                    viewModel.search()
                }
                .arcaneButton()
                
                List(viewModel.creatures) { creature in
                    VStack(alignment: .leading) {
                        Text(creature.name)
                            .font(.headline)
                        Text(creature.alignment)
                            .font(.caption)
                    }
=======

            VStack {
                TextField("", text: $viewModel.searchText, prompt: Text("Search Creature").foregroundColor(.black))
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
                    ForEach(viewModel.creatures) { creature in
                        VStack(alignment: .leading) {
                            Text(creature.name)
                                .font(.headline)
                            Text(creature.alignment)
                                .font(.caption)
                        }
                    }

                    // Pagination trigger at bottom of list
//                    if viewModel.hasMorePages {
//                        HStack {
//                            Spacer()
//                            ProgressView()
//                                .onAppear { viewModel.fetchCreatures() }
//                            Spacer()
//                        }
//                        .listRowBackground(Color.clear)
//                    }
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Bestiary")
    }
}

#Preview {
    BestiaryLookupView()
}
