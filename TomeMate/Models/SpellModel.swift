//
//  SpellModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

struct SpellModel: Identifiable, Codable {
    let id: String
    let name: String
    let level: Int
    let school: String
    let description: String
    let damage_type: String?
    let saving_throw_type: String?
}
