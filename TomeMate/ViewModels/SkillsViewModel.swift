//
//  SkillsViewModel.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import Foundation
import Combine

class SkillsViewModel: ObservableObject {
    
    @Published var skills: [SkillsModel] = []
    
    @Published var errorMessage: String?
    
    
    
    init(){
        fetchSkills()
    }
    
    func fetchSkills(){
        NetworkManager.shared.fetchSkills{
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let skills):
                    self.skills = skills
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching skills: \(error)")
                }
            }
        }
    }
}
