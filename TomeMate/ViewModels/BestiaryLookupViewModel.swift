//
//  BestiaryLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

// testing

<<<<<<< HEAD
class BestiaryLookupViewModel: ObservableObject {
    
    @Published var creatures: [CreatureModel] = []
    @Published var searchText = ""
    
    func search() {
        let queryID = searchText.lowercased().replacingOccurrences(of: " ", with: "-")
        
        NetworkManager.shared.fetchCreatures(by: queryID) { result in
            switch result {
            case .success(let creature):
                self.creatures = [creature]
            case .failure(let error):
                print(error)
                self.creatures = []
=======
//class BestiaryLookupViewModel: ObservableObject {
//    
//    @Published var creatures: [CreatureModel] = []
//    @Published var searchText = ""
//    
//    func search() {
//        let queryID = searchText.lowercased().replacingOccurrences(of: " ", with: "-")
//        
//        NetworkManager.shared.fetchCreatures(by: queryID) { result in
//            switch result {
//            case .success(let creature):
//                self.creatures = [creature]
//            case .failure(let error):
//                print(error)
//                self.creatures = []
//            }
//        }
//    }
//    
////    func search() {
////        NetworkManager.shared.fetchCreatures(query: searchText) { result in
////            switch result {
////            case .success(let creatures):
////                self.creatures = creatures
////            case .failure(let error):
////                print(error)
////                self.creatures = []
////            }
////        }
////    }
//}

class BestiaryLookupViewModel: ObservableObject {
    @Published var allCreatures: [CreatureModel] = []  // full list from backend
    @Published var creatures: [CreatureModel] = []     // filtered list
    @Published var searchText = "" {
        didSet { filterCreatures() }
    }
    @Published var errorMessage: String?
    @Published var isLoading = false

    init() {
        fetchAllCreatures()
    }

    // Fetch all creatures once
    func fetchAllCreatures() {
        isLoading = true
        NetworkManager.shared.fetchCreatures(query: "") { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let paginated):
                self.allCreatures = paginated.data
                self.creatures = paginated.data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
            }
        }
    }

<<<<<<< HEAD
=======
    // Filter locally based on searchText
    private func filterCreatures() {
        if searchText.isEmpty {
            creatures = allCreatures
        } else {
            let lowercased = searchText.lowercased()
            creatures = allCreatures.filter { $0.name.lowercased().contains(lowercased) }
        }
    }
>>>>>>> 5d27657d6188f90f8e73648ea20374fbb40dc312
}
