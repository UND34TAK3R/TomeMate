//
//  ItemLookupView.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import SwiftUI

struct ItemLookupView: View {
    
    @StateObject private var viewModel = ItemLookupViewModel()
    
    var body: some View {
        ZStack {
            ArcaneTheme.background.ignoresSafeArea()
            ArcaneParticlesView()
            
            VStack {
                
                ArcaneTextField(title: "Search Item", text: $viewModel.searchText)
                
                List(viewModel.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.rarity)
                            .font(.caption)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
        .navigationTitle("Items")
    }
}

#Preview {
    ItemLookupView()
}
