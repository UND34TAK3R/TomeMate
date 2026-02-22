//
//  CreatureModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

struct CreatureModel: Identifiable, Codable {
    let id: String
    let name: String
    let size: String
    let type: String
    let alignment: String
    let armor_class: Int
    let hit_points: Int
    let challenge_rating: String
}
