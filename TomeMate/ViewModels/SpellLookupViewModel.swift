//
//  SpellLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

class SpellLookupViewModel: ObservableObject {
<<<<<<< HEAD
    
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
=======
    @Published var spells: [SpellModel] = []
    @Published var searchText = "" {
        didSet {
            // Reset to page 1 and re-fetch when search changes
            currentPage = 1
            totalPages = 1
            spells = []
            fetchSpells()
        }
    }
    @Published var errorMessage: String?
    @Published var isLoading = false

    private(set) var currentPage = 1
    private(set) var totalPages = 1
    var hasMorePages: Bool { currentPage <= totalPages }

    init() { fetchSpells() }

    func fetchSpells() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        NetworkManager.shared.fetchSpells(query: searchText, page: currentPage) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let paginated):
                self.totalPages = paginated.total_pages
                self.spells.append(contentsOf: paginated.data)
                self.currentPage += 1
            case .failure(let error):
                self.errorMessage = error.localizedDescription
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
            }
        }
    }

<<<<<<< HEAD
    private func filterSpells() {
        if searchText.isEmpty {
            spells = allSpells
        } else {
            spells = allSpells.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
=======
    func resetAndFetch() {
        currentPage = 1
        totalPages = 1
        spells = []
        fetchSpells()
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
    }
}
