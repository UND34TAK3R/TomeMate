//
//  BestiaryLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct BestiaryLookupView: View {
    
    
    @StateObject private var viewModel = BestiaryLookupViewModel()
    
    var body: some View {
        ZStack {
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()
            
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
