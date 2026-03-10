//
//  RaceModelView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import Foundation
import Combine

class RacesViewModel: ObservableObject {
    
    @Published var races: [RaceModel] = []
    
    @Published var errorMessage: String?
    
    
    
    init(){
        fetchRaces()
    }
    
    func fetchRaces(){
        NetworkManager.shared.fetchRaces(query: ""){
            result in
            switch result {
            case .success(let races):
                self.races = races
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching races: \(error)")
            }
        }
    }
}
