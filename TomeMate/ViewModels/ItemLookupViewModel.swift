//
//  ItemLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

<<<<<<< HEAD
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
=======
//class ItemLookupViewModel: ObservableObject {
//    @Published var items: [ItemModel] = []
//    @Published var searchText = "" {
//        didSet {
//            // Reset to page 1 and re-fetch when search changes
//            currentPage = 1
//            totalPages = 1
//            items = []
//            fetchItems()
//        }
//    }
//    @Published var errorMessage: String?
//    @Published var isLoading = false
//
//    private(set) var currentPage = 1
//    private(set) var totalPages = 1
//    var hasMorePages: Bool { currentPage <= totalPages }
//
//    init() { fetchItems() }
//
//    func fetchItems() {
//        guard !isLoading && hasMorePages else { return }
//        isLoading = true
//
//        NetworkManager.shared.fetchItems(query: searchText, page: currentPage) { [weak self] result in
//            guard let self else { return }
//            self.isLoading = false
//            switch result {
//            case .success(let paginated):
//                self.totalPages = paginated.total_pages
//                self.items.append(contentsOf: paginated.data)
//                self.currentPage += 1
//            case .failure(let error):
//                self.errorMessage = error.localizedDescription
//            }
//        }
//    }
//
//    func resetAndFetch() {
//        currentPage = 1
//        totalPages = 1
//        items = []
//        fetchItems()
//    }
//}

class ItemLookupViewModel: ObservableObject {
    @Published var allItems: [ItemModel] = []
    @Published var items: [ItemModel] = []
    @Published var searchText = "" {
        didSet { filterItems() }
    }
    @Published var errorMessage: String?
    @Published var isLoading = false

    private(set) var currentPage = 1
    private(set) var totalPages = 1
    var hasMorePages: Bool { currentPage <= totalPages }

    init() { fetchItems() }

    func fetchItems() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true

        NetworkManager.shared.fetchItems(query: searchText, page: currentPage) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let paginated):
                self.allItems.append(contentsOf: paginated.data)
                self.currentPage += 1
                self.totalPages = paginated.total_pages
                self.filterItems()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
            }
        }
    }

<<<<<<< HEAD
=======
    func resetAndFetch() {
        currentPage = 1
        totalPages = 1
        allItems = []
        items = []
        fetchItems()
    }

>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
    private func filterItems() {
        if searchText.isEmpty {
            items = allItems
        } else {
            items = allItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
