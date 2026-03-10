//
//  CharacterFormData.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import Foundation

struct CharacterFormData {
    let id:UUID = UUID()
    var name: String = ""
    var age: Int = 0
    var alignment: String = ""
    var background: BackgroundModel = BackgroundModel(id: "", name: "", skillProficiencies: [])
    var charImg: String = ""
    var race: RaceModel = RaceModel(id: "", name: "", languages: [], speed: 0, traits: [])
    var languages: [LanguageModel] = []
    var subrace: SubraceModel? = nil
    var strength: Int = 10
    var dexterity: Int = 10
    var intelligence: Int = 10
    var constitution: Int = 10
    var wisdom: Int = 10
    var charisma: Int = 10
    var skills: [SkillsModel] = []
    var charClass: ClassesModel? = nil
    var subclass: SubclassModel? = nil
    var xp: Bool = false
}

struct RaceModel: Identifiable, Codable, Equatable{
    var id: String
    var name: String
    var languages: [String]
    var speed: Int
    var traits: [String]
}

struct SubraceModel: Identifiable, Codable, Equatable{
    var id: String
    var name: String
    var raceName:String
    var languages: [String]
    var traits: [String]
    var spells: [String]
}

struct SkillsModel: Identifiable, Codable, Equatable{
    var id: String
    var name: String
    var ability: String
    var isProficient: Bool
}

struct ClassesModel: Identifiable, Codable, Equatable{
    var id:String
    var name: String
    var source: String
    var page: Int
    var hitDice: Int
    var primaryAbility: String
}

struct SubclassModel: Identifiable, Codable, Equatable{
    var id:String
    var name: String
    var shortName: String
    var className: String
    var source: String
    var page: Int
}

struct BackgroundModel: Identifiable, Codable, Equatable{
    var id:String
    var name: String
    var skillProficiencies: [String]
}

struct LanguageModel: Identifiable, Codable, Equatable{
    var id: String
    var name: String
}


