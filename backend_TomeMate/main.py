from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import json

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


# Add this at the very bottom
if __name__ == "__main__":
    print("\n=== Registered Routes ===")
    for route in app.routes:
        print(f"{route.methods} {route.path}")
    print("========================\n")