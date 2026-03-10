//
//  TomeMateHolder.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import Foundation
import CoreData
import Combine

final class TomeMateHolder: ObservableObject {
    @Published var characters: [Character] = []
    let service = NetworkManager()
    
    init(_ context: NSManagedObjectContext){
        // refresh all
        refreshAll(context)
    }
    //MARK: REFRESH FUNCTIONS
    
    func refreshAll(_ context: NSManagedObjectContext){
        refreshCharacters(context)
    }
    
    func refreshCharacters(_ context: NSManagedObjectContext){
        characters = fetchCharacters(context)
    }
    
    //MARK: FETCHERS
    func fetchCharacters(_ context: NSManagedObjectContext) -> [Character]{
        do {return try context.fetch(charactersFetch())}
        catch {fatalError("Failed to fetch characters: \(error)")}
    }
    
    //MARK: FETCH REQUESTS
    func charactersFetch() -> NSFetchRequest<Character>{
        let request = Character.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Character.createdAt, ascending: true)]
        return request
    }
    
    //MARK: - CHARACTER
    func  createCharacter(formData: CharacterFormData, stat: Stats, skills: [SkillProficiencies], classes: Classes, _ context:NSManagedObjectContext) async -> Character{
        let c = Character(context: context)
        
        let age = Int16(formData.age)
        let name = formData.name
        let alignment = formData.alignment
        let stats = stat
        let languages = formData.languages.map(\.name)
        c.name = name
        c.age = age
        c.alignment = alignment
        c.stats = stat
        c.armorClass = Int16(10 + (c.stats?.dexModifier())!)
        c.background = formData.background.name
        c.createdAt = Date()
        c.experiencePoints = 0
        c.useXp = formData.xp
        c.gold = 0
        c.hp = Int16(Double(formData.charClass!.hitDice) + Double( c.stats!.conModifier())) //replace with function
        c.initiative = Int16(c.stats!.dexModifier())
        c.inspiration = 0
        c.languages = languages
        c.level = 1
        c.race = formData.race.name
        c.subrace = formData.subrace!.name
        c.speed = String(formData.race.speed)
        c.proficiencyBonus = 2
        for skill in skills {
            c.addToSkillProf(skill)
        }
        c.passivePerception = Int16(c.calculatePassivePerception())
        c.addToClasses(classes)
        //find subrace related spells
        func fetchSpells( subrace: SubraceModel,_ context: NSManagedObjectContext) async -> [Spell] {
            var spells: [Spell] = []
            for spellID in subrace.spells {
                do { let spellModel = try await service.fetchSpell(id: spellID)
                    let savedSpell = createSpell(spell: spellModel, context)
                    spells.append(savedSpell)
                } catch { print("Failed to fetch spell:", error) }
            }
            return spells
        }
        
        let spells = await fetchSpells(
            subrace: formData.subrace!,
            context
        )

        for spell in spells {
            c.addToSpells(spell)
        }
        saveContext(context)
        return c
    }
    
    func deleteCharacter(_ character: Character, _ context: NSManagedObjectContext){
        context.delete(character)
        saveContext(context)
    }
    
    
    // MARK: - STATS
    func createStat(formData: CharacterFormData, _ context: NSManagedObjectContext)-> Stats{
        let strength = formData.strength
        let dexterity = formData.dexterity
        let intelligence = formData.intelligence
        let charisma = formData.charisma
        let wisdom = formData.wisdom
        let constitution = formData.constitution
        
        let s = Stats(context: context)
        s.strength = Int16(strength)
        s.dexterity = Int16(dexterity)
        s.intelligence = Int16(intelligence)
        s.charisma = Int16(charisma)
        s.wisdom = Int16(wisdom)
        s.constitution = Int16(constitution)
        
        saveContext(context)
        return s
    }
    
    //MARK: - SKILLS
    func createSkill(formData: CharacterFormData, _ context: NSManagedObjectContext)-> [SkillProficiencies]{
        var skills: [SkillProficiencies] = []
        for skill in formData.skills{
            let s = SkillProficiencies(context: context)
            s.name = skill.name
            s.ability = skill.ability
            s.isProficient = skill.isProficient
            s.id = skill.id
            saveContext(context)
            skills.append(s)
        }
        return skills
    }
    
    func createClass(classes: ClassesModel, subclass:SubclassModel, _ context: NSManagedObjectContext) -> Classes{
        let c = Classes(context: context)
        c.classId = classes.id
        c.hitDice = Int16( classes.hitDice)
        c.level = 1
        c.name = classes.name
        c.primaryAbility = classes.primaryAbility
        c.shortName = subclass.shortName
        c.subclass = subclass.name
        saveContext(context)
        return c
    }
    
    
    //MARK: - SPELLS
    func createSpell(spell:SpellModel, _ context: NSManagedObjectContext)
    -> Spell{
        let s = Spell(context: context)
        s.name = spell.name
        s.level = spell.level
        s.school = spell.school
        s.castTime = spell.cast_time
        s.components = spell.components
        s.materials = spell.material
        s.durationType = spell.durationType
        s.is_concentration = spell.is_concentration
        s.spell_duration_type = spell.spell_duration_unit
        s.durationAmount = spell.durationAmount ?? 0
        s.range_type = spell.range_type
        s.range_amount = spell.range_amount ?? 0
        s.range_unit = spell.range_unit
        s.desc = spell.description
        s.damage_type = spell.damage_type
        s.condition_type = spell.condition_type
        s.saving_throw_type = spell.saving_throw_type
        
        saveContext(context)
        return s
    }
    
    //MARK: SAVE
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshAll(context) // always refresh
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
    
