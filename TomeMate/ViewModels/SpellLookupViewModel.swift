//
//  SpellLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class SpellLookupViewModel: ObservableObject {
    
    @Published var allSpells: [SpellModel] = []
    @Published var spells: [SpellModel] = []
    @Published var searchText = "" {
        didSet {
            filterSpells()
        }
    }
    @Published var errorMessage: String?

    init() {
        fetchAllSpells()
    }

    func fetchAllSpells() {
        NetworkManager.shared.fetchSpells(query: "") { result in
            switch result {
            case .success(let spells):
                self.allSpells = spells
                self.spells = spells
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching spells:", error)
            }
        }
    }

    private func filterSpells() {
        if searchText.isEmpty {
            spells = allSpells
        } else {
            spells = allSpells.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
