//
//  PlayerProfile.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//

import Foundation
import FirebaseFirestore

struct PlayerProfile: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var createdAt: Date
    var lastLoginAt: Date
    var isActive: Bool
    
    init(id: String, email: String) {
        self.id = id
        self.email = email
        self.createdAt = Date()
        self.lastLoginAt = Date()
        self.isActive = true
    }
}
