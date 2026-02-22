//
//  ItemModel.swift
//  TomeMate
//
//  Created by NRD on 21/02/2026.
//

import Foundation

struct ItemModel: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let rarity: String
    let description: String
    let isMagic: Bool
}
