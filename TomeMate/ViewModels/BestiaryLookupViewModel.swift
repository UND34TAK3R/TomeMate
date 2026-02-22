//
//  BestiaryLookupViewModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation
import Combine

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
            }
        }
    }

}
