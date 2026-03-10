//
//  LanguageViewModel.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//

import Foundation
import Combine

class LanguageViewModel: ObservableObject {
    
    @Published var languages: [LanguageModel] = []
    
    @Published var errorMessage: String?
    
    
    
    init(){
        fetchLanguages()
    }
    
    func fetchLanguages(){
        NetworkManager.shared.fetchLanguages{
            result in
            switch result {
            case .success(let languages):
                self.languages  = languages
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching races: \(error)")
            }
        }
    }
}
