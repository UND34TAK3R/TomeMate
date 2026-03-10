//
//  Stats.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-02.
//

import Foundation
import CoreData

extension Stats {
    func strModifier() -> Int {
        return Int(floor(Double((strength - 10) / 2)))
    }
    func dexModifier() -> Int {
        return Int(floor(Double((dexterity - 10) / 2)))
    }
    func conModifier() -> Int {
        return Int(floor(Double((constitution - 10) / 2)))
    }
    func intModifier() -> Int {
        return Int(floor(Double((intelligence - 10) / 2)))
    }
    func wisModifier() -> Int {
        return Int(floor(Double((wisdom - 10) / 2)))
    }
    func chaModifier() -> Int {
        return Int(floor(Double((charisma - 10) / 2)))
    }
}
