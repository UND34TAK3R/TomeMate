from turtle import speed
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import json
import re

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def flatten_entries(entries):
    result = []
    for e in entries:
        if isinstance(e, str):
            result.append(e)
        elif isinstance(e, dict):
            name = e.get("name")
            if name:
                result.append(f"\n{name}:")
            sub = e.get("entries")
            if sub:
                result.append(flatten_entries(sub))
    return "\n".join(result)

def slugify(name: str):
    return name.lower().replace(" ", "-")

# Load Spells Data
with open("Data/spells-xphb.json") as f:
    raw_spells = json.load(f)

def map_spell(spell):
    components = spell.get("components", {})
    duration_list = spell.get("duration", [])
    duration = duration_list[0] if duration_list else {}
    
    range_obj = spell.get("range", {})
    distance = range_obj.get("distance", {})
    damageInflict = spell.get("damageInflict", [])
    conditionsInflict = spell.get("conditionsInflict", [])
    savingThrow = spell.get("savingThrow", [])
    affectsCreatureType = spell.get("affectsCreatureType", [])

    vocal = bool(components.get("v"))
    somatic = bool(components.get("s"))
    material = components.get("m") if isinstance(components.get("m"), str) else None

    letters = []
    if vocal:
        letters.append("V")
    if somatic:
        letters.append("S")
    if material is not None or components.get("m") is True:
        letters.append("M")

    spell_duration = duration.get("duration", {})

    return {
        "id": slugify(spell["name"]),
        "name": spell["name"],
        "level": spell["level"],
        "school": spell["school"],
        "cast_time": spell["time"][0]["unit"],
        "components": letters,
        "material": material,
        "durationType": duration.get("type"),
        "is_concentration": duration.get("concentration", False),
        "spell_duration_unit": spell_duration.get("type") if spell_duration else None,
        "durationAmount": spell_duration.get("amount") if spell_duration else None,
        "range_type": range_obj.get("type"),
        "range_amount": distance.get("amount"),
        "range_unit": distance.get("type"),
        "description": flatten_entries(spell.get("entries", [])),
        "damage_type": damageInflict[0] if damageInflict else None,
        "condition_type": conditionsInflict[0] if conditionsInflict else None,
        "saving_throw_type": savingThrow[0] if savingThrow else None,
        "affects_creature_type": affectsCreatureType[0] if affectsCreatureType else None,
    }

mapped_spells = [map_spell(s) for s in raw_spells["spell"]]

@app.get("/spells")
def get_spells(
    level: int = None,
    school: str = None,
    name: str = None,
    damage_type: str = None,
    saving_throw: str = None
):
    results = mapped_spells
    
    if level is not None:
        results = [s for s in results if s["level"] == level]
    
    if school:
        results = [s for s in results if s["school"].lower() == school.lower()]
    
    if name:
        results = [s for s in results if name.lower() in s["name"].lower()]
    
    if damage_type:
        results = [s for s in results if s["damage_type"] and damage_type.lower() in s["damage_type"].lower()]
    
    if saving_throw:
        results = [s for s in results if s["saving_throw_type"] and saving_throw.lower() in s["saving_throw_type"].lower()]
    
    return results

@app.get("/spells/{spell_id}")
def get_spell_by_id(spell_id: str):
    for spell in mapped_spells:
        if spell["id"] == spell_id:
            return spell
    raise HTTPException(status_code=404, detail=f"Spell with id '{spell_id}' not found")




### Load Bestiary Data ###

with open("Data/bestiary-xphb.json") as b:
    raw_bestiary = json.load(b)

def map_bestiary(creature):

    name = creature.get("name")

    if not name:
        return None   # skip this monster

    return {
        "id": slugify(creature["name"]),
        "name": creature["name"],
        "size" : creature["size"],
        "type" : creature["type"],
        "subtype" : creature["subtype"],
        "alignment" : creature["alignment"],
        "armor_class" : creature["armor_class"],
        "hit_points" : creature["hit_points"],
        "hit_dice" : creature["hit_dice"],
        "speed" : creature["speed"],
        "strength" : creature["strength"],
        "dexterity" : creature["dexterity"],
        "constitution": creature[ "constitution"],
        "intelligence": creature["intelligence"],
        "wisdom": creature["wisdom"],
        "charisma": creature["charisma"],
        "damage_vulnerabilities": creature[ "damage_vulnerabilities"],
        "damage_resistances": creature["damage_resistances"],
        "damage_immunities": creature[ "damage_immunities"],
        "condition_immunities": creature["condition_immunities"],
        "senses": creature["senses"],
        "languages": creature["languages"],
        "challenge_rating": creature[ "challenge_rating"],
    }

mapped_bestiary = [map_bestiary(b) for b in raw_bestiary["creature"]]

@app.get("/creatures/{creature_id}")
def get_creature_by_id(creature_id: str):
    for creature in mapped_bestiary:
        if creature["id"] == creature_id:
            return creature
    raise HTTPException(status_code=404, detail=f"Creature with id '{creature_id}' not found")


@app.get("/creatures")
def get_creatures():
    results = mapped_bestiary
    return results



###### Items ###########



# Load items data
with open("Data/items.json") as f:
    raw_items = json.load(f)


def slugify(text):
    """Convert text to URL-friendly slug"""
    text = text.lower()
    text = re.sub(r'[^\w\s-]', '', text)
    text = re.sub(r'[-\s]+', '-', text)
    return text.strip('-')


def map_item(item):
    """
    Normalize item data for Core Data - simple flat structure
    """
    name = item.get("name")
    if not name:
        return None
    
    # Get type - can be simple string or complex
    item_type = item.get("type", "")
    if isinstance(item_type, dict):
        item_type = ""  # Ignore complex types for now
    
    # Get entries text - join into single string
    entries = item.get("entries", [])
    description = ""
    if isinstance(entries, list):
        text_parts = []
        for entry in entries:
            if isinstance(entry, str):
                text_parts.append(entry)
            elif isinstance(entry, dict) and "entries" in entry:
                # Get nested text
                nested = entry.get("entries", [])
                if isinstance(nested, list):
                    text_parts.extend([e for e in nested if isinstance(e, str)])
        description = " ".join(text_parts)
    
    # Get attunement requirement
    req_attune = item.get("reqAttune", "")
    if isinstance(req_attune, bool):
        req_attune = "Yes" if req_attune else ""
    
    return {
        "id": slugify(name),
        "name": name,
        "type": item_type,
        "rarity": item.get("rarity", ""),
        "reqAttune": req_attune,
        "weight": item.get("weight", 0.0),
        "value": item.get("value", 0),
        "description": description,
        
        # Boolean flags
        "wondrous": item.get("wondrous", False),
        "isMagic": item.get("rarity") not in [None, "none", ""],
        
        # Bonuses (for weapons/spells)
        "bonusWeapon": item.get("bonusWeapon", ""),
        "bonusAc": item.get("bonusAc", ""),
        "bonusSpellAttack": item.get("bonusSpellAttack", ""),
        "bonusSpellSaveDc": item.get("bonusSpellSaveDc", ""),
    }


# Map all items
mapped_items = [map_item(i) for i in raw_items["item"] if map_item(i)]


@app.get("/items/{item_id}")
def get_item_by_id(item_id: str):
    for item in mapped_items:
        if item["id"] == item_id:
            return item
    raise HTTPException(status_code=404, detail=f"Item '{item_id}' not found")


@app.get("/items")
def get_items(
    q: str = None,
    rarity: str = None,
    type: str = None,
    magic: bool = None
):
    results = mapped_items
    
    # Search by name
    if q:
        q_lower = q.lower()
        results = [i for i in results if q_lower in i["name"].lower()]
    
    # Filter by rarity
    if rarity:
        results = [i for i in results if i["rarity"].lower() == rarity.lower()]
    
    # Filter by type
    if type:
        results = [i for i in results if type.lower() in i["type"].lower()]
    
    # Filter magic items
    if magic is not None:
        results = [i for i in results if i["isMagic"] == magic]
    
    return results

 ###### Class #########

with open("Data/classes.json") as f:
    data = json.load(f)

classes = data["classes"]
subclasses = data["subclasses"]

@app.get("/classes")
def get_classes(name: str = None):
  
    results = classes
    
    if name:
        name_lower = name.lower()
        results = [c for c in results if name_lower in c["name"].lower()]
    
   
    
    return results


@app.get("/classes/{class_id}")
def get_class_by_id(class_id: str):
    """Get a specific class by ID"""
    for cls in classes:
        if cls["id"] == class_id:
            return cls
    raise HTTPException(status_code=404, detail=f"Class '{class_id}' not found")


@app.get("/subclasses")
def get_subclasses(className: str = None, name: str = None):
    results = subclasses
    
    if className:
        results = [s for s in results if s["className"].lower() == className.lower()]
    
    if name:
        name_lower = name.lower()
        results = [s for s in results if name_lower in s["name"].lower()]
    
    
    return results


@app.get("/subclasses/{subclass_id}")
def get_subclass_by_id(subclass_id: str):
    for sub in subclasses:
        if sub["id"] == subclass_id:
            return sub
    raise HTTPException(status_code=404, detail=f"Subclass '{subclass_id}' not found")

 ##### Races ########

def extract_spells(additional_spells):
    spells = set()

    def clean_spell_name(raw):
        return raw.split("|")[0].split("#")[0].strip().title()

    def extract_from_level_block(block):
        if isinstance(block, list):
            for s in block:
                if isinstance(s, str):
                    spells.add(clean_spell_name(s))
        elif isinstance(block, dict):
            for _, inner in block.items():
                extract_from_level_block(inner)

    for spell_entry in (additional_spells or []):
        if not isinstance(spell_entry, dict):
            continue
        for key, value in spell_entry.items():
            if key == "ability":
                continue
            if isinstance(value, dict):
                for level_key, level_block in value.items():
                    extract_from_level_block(level_block)

    return sorted(spells)


def extract_traits(entries):
    SKIP_NAMES = {"age", "languages", "language", "alignment", "size"}
    traits = []
    for entry in (entries or []):                      # guard: null entries
        if not isinstance(entry, dict):
            continue
        name = entry.get("name", "")
        if name and name.lower() not in SKIP_NAMES:
            traits.append(name)
    return traits


with open("Data/races.json") as s:
    raw_races = json.load(s)


def map_race(race):
    name = race.get("name")
    if not name:
        return None

    traits = extract_traits(race.get("entries"))        # passes None safely

    if not traits:
        for item in (race.get("traitTags") or []):      # guard: null traitTags
            if isinstance(item, str):
                traits.append(item)

    if name.lower() == "dragonborn":
        if "Breath Weapon" not in traits:
            traits.append("Breath Weapon")
        if "Draconic Ancestry" not in traits:
            traits.append("Draconic Ancestry")

    languages = []
    for item in (race.get("languageProficiencies") or []):  # guard: null
        if isinstance(item, dict):
            for lang, value in item.items():
                if value is True:
                    languages.append(lang.capitalize())

    speed = race.get("speed") or {}                     # guard: null speed
    if isinstance(speed, int):
        speed = {"walk": speed}

    ability = {}
    ability_list = race.get("ability") or []            # guard: null ability
    if isinstance(ability_list, list) and ability_list:
        ability = ability_list[0]

    spells = extract_spells(race.get("additionalSpells"))

    return {
        "id": slugify(name),
        "name": name,
        "languages": languages,
        "speed": speed,
        "traits": traits,
        "spells": spells,
        "ability": ability,
    }


mapped_races = [r for r in (map_race(r) for r in raw_races["race"]) if r]


@app.get("/races/{race_id}")
def get_race_by_id(race_id: str):
    for race in mapped_races:
        if race["id"] == race_id:
            return race
    raise HTTPException(status_code=404, detail=f"Race with id '{race_id}' not found")


@app.get("/races")
def get_races():
    return mapped_races


####### Subraces ########

def map_subrace(subrace):
    name = subrace.get("name")
    if not name:
        return None

    languages = []
    for item in (subrace.get("languageProficiencies") or []):   # guard: null
        if isinstance(item, dict):
            for lang, value in item.items():
                if value is True:
                    languages.append(lang.capitalize())

    traits = extract_traits(subrace.get("entries"))             # passes None safely

    if not traits:
        for item in (subrace.get("traitTags") or []):           # guard: null
            if isinstance(item, str):
                traits.append(item)

    ability = {}
    ability_list = subrace.get("ability") or []                 # guard: null
    if isinstance(ability_list, list) and ability_list:
        ability = ability_list[0]

    spells = extract_spells(subrace.get("additionalSpells"))

    return {
        "id": slugify(name),
        "name": name,
        "raceName": subrace.get("raceName"),
        "languages": languages,
        "traits": traits,
        "spells": spells,
        "ability": ability,
    }


mapped_subraces = [r for r in (map_subrace(r) for r in raw_races["subrace"]) if r]

@app.get("/subraces/{subrace_id}")
def get_subrace_by_id(subrace_id: str):
    for subrace in mapped_subraces:
        if subrace["id"] == subrace_id:
            return subrace
    raise HTTPException(status_code=404, detail=f"Subrace with id '{subrace_id}' not found")

@app.get("/subraces")
def get_subraces(raceName: str = None):
    # If no raceName provided, return all subraces
    if not raceName:
        return mapped_subraces
    
    # Filter by raceName
    results = [s for s in mapped_subraces if s.get("raceName", "").lower() == raceName.lower()]
    return results

######## Languages #########

with open("Data/languages.json") as l:
    raw_languages = json.load(l)

def map_language(language):

    name = language.get("name")

    if not name:
        return None   # skip this language

    return {
        "id": slugify(language["name"]),
        "name": language["name"]
    }

mapped_language = [map_language(l) for l in raw_languages["language"]]

@app.get("/languages/{language_id}")
def get_language_by_id(language_id: str):
    for language in mapped_language:
        if language["id"] == language_id:
            return language
    raise HTTPException(status_code=404, detail=f"Language with id '{language_id}' not found")


@app.get("/languages")
def get_languages():
    results = mapped_language
    return results

###### Senses #########

with open("Data/senses.json") as s:
    raw_senses = json.load(s)

def map_senses(sense):

    name = sense.get("name")

    if not name:
        return None   # skip this sense

    return {
        "id": slugify(sense["name"]),
        "name": sense["name"],
        "entry": sense["entry"]
    }

mapped_senses = [map_senses(s) for s in raw_senses["sense"]]

@app.get("/senses/{sense_id}")
def get_sense_by_id(sense_id: str):
    for sense in mapped_senses:
        if sense["id"] == sense_id:
            return sense
    raise HTTPException(status_code=404, detail=f"Sense with id '{sense_id}' not found")


@app.get("/senses")
def get_senses():
    results = mapped_senses
    return results

###### Skills ######

with open("Data/skills.json") as l:
    raw_skills = json.load(l)

def map_skill(skill):

    name = skill.get("name")

    if not name:
        return None   # skip this skill

    return {
        "id": slugify(skill["name"]),
        "name": skill["name"],
        "ability" : skill["ability"],
        "entry" : skill["entry"]
    }

mapped_skill = [map_skill(l) for l in raw_skills["skill"]]

@app.get("/skills/{skill_id}")
def get_skill_by_id(skill_id: str):
    for skill in mapped_skill:
        if skill["id"] == skill_id:
            return skill
    raise HTTPException(status_code=404, detail=f"Skill with id '{skill_id}' not found")


@app.get("/skills")
def get_skills():
    results = mapped_skill
    return results

# Add this at the very bottom
if __name__ == "__main__":
    print("\n=== Registered Routes ===")
    for route in app.routes:
        print(f"{route.methods} {route.path}")

    print("========================\n")
