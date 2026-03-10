//
//  BackgroundViewModel.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import Foundation
import Combine

class BackgroundViewModel: ObservableObject {
    
    @Published var backgrounds: [BackgroundModel] = []
    
    @Published var errorMessage: String?
    
    
    
    init(){
        fetchBackgrounds()
    }
    
    func fetchBackgrounds(){
        NetworkManager.shared.fetchBackgrounds(){
            result in
            switch result {
            case .success(let backgrounds):
                self.backgrounds = backgrounds
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching backgrounds: \(error)")
            }
        }
    }
}
