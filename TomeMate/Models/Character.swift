//
//  Character.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-02.
//

import Foundation
import CoreData

extension Character {
    func isProficientPerception() -> Bool {
        guard let skills = skillProf as? Set<SkillProficiencies> else {
            return false
        }

        return skills.contains {
            $0.name == "Perception" && $0.isProficient
        }
    }
    
    func calculatePassivePerception() -> Int{
        let wisModifier = stats?.wisModifier()
        let proficiencyBonus = isProficientPerception() ? proficiencyBonus : 0
        return Int(10 + wisModifier! + Int(proficiencyBonus))
    }
}
