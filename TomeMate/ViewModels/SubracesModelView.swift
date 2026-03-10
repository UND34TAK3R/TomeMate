//
//  SubracesModelView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import Foundation
import Combine

class SubracesViewModel: ObservableObject {
    
    @Published var subraces: [SubraceModel] = []
    
    @Published var errorMessage: String?
    
    
    func fetchSubraces(raceName:String) {
        NetworkManager.shared.fetchSubraces(query: raceName) { result in
            switch result {
            case .success(let subraces):
                self.subraces = subraces
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching subraces", error)
            }
        }
    }
}
