//
//  ClassesViewModel.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import Foundation
import Combine

class ClassesViewModel: ObservableObject {
    
    @Published var classes: [ClassesModel] = []
    
    @Published var errorMessage: String?
    
    
    
    init(){
        fetchClasses()
    }
    
    func fetchClasses(){
        NetworkManager.shared.fetchClasses(query: ""){
            result in
            switch result {
            case .success(let classes):
                self.classes = classes
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching classes: \(error)")
            }
        }
    }
}
