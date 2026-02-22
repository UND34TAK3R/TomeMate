//
//  ItemLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class ItemLookupViewModel: ObservableObject {
    
    @Published var allItems: [ItemModel] = []
    @Published var items: [ItemModel] = []
    @Published var searchText = "" {
        didSet {
            filterItems()
        }
    }
    @Published var errorMessage: String?

    init() {
        fetchAllItems()
    }

    func fetchAllItems() {
        NetworkManager.shared.fetchItems(query: "") { result in
            switch result {
            case .success(let items):
                self.allItems = items
                self.items = items
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching spells:", error)
            }
        }
    }

    private func filterItems() {
        if searchText.isEmpty {
            items = allItems
        } else {
            items = allItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
