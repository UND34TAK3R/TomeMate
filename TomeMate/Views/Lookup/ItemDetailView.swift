//
//  ItemDetailView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct ItemDetailView: View {
    let item: ItemModel
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            Color.tomeBg
                .ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.custom("Cinzel-Regular", size: 35))
                            .foregroundStyle(Color.tomeGoldLight)
                        Text(item.type)
                            .font(.custom("IMFellEnglish-Regular", size: 20))
                            .italic()
                            .foregroundStyle(Color.tomeGoldDim)
                        Text(item.rarity)
                            .font(.custom("Cinzel-Regular", size: 20))
                            .tracking(1.5)
                            .foregroundStyle(Color.tomeGold)
                    }
                    .fadeUp(appeared, delay: 0.05)
                    
                    DecorativeRuleView()
                    
                    // Description
                    if !item.description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Cinzel-Regular", size: 30))
                                .tracking(2)
                                .foregroundStyle(Color.tomeCrimson)
                            Text(item.description)
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .fadeUp(appeared, delay: 0.1)
                    }
                    
                    // isMagic
                    if item.isMagic {
                        DecorativeRuleView()
                        typeSpecificSection(for: item)
                            .fadeUp(appeared, delay: 0.15)
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
    
    @ViewBuilder
    private func typeSpecificSection(for item: ItemModel) -> some View {
        let type = item.type.lowercased()

        // Weapons
        if ["ranged weapon", "melee weapon"].contains(type) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Weapon")
                    .font(.custom("Cinzel-Regular", size: 30))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                if let bonus = item.bonusWeapon, !bonus.isEmpty {
                    ItemDetailRow(label: "Attack Bonus", value: "\(bonus)")
                }
                if let weight = item.weight {
                    ItemDetailRow(label: "Weight", value: "\(weight) lbs")
                }
                if let value = item.value, value != 0 {
                    ItemDetailRow(label: "Value", value: "\(value) gp")
                }
                DecorativeRuleView()
            }

        }
        
        // Armor
        if ["light armor", "medium armor", "heavy armor"].contains(type) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Armor")
                    .font(.custom("Cinzel-Regular", size: 30))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                // Should add section for AC
                if let bonus = item.bonusAc, !bonus.isEmpty {
                    ItemDetailRow(label: "AC Bonus", value: "\(bonus)")
                }
                if let weight = item.weight {
                    ItemDetailRow(label: "Weight", value: "\(weight) lbs")
                }
                DecorativeRuleView()
            }

        }
        
        // Spell Attack / Spell Save Dc
        if (item.bonusSpellAttack.map { !$0.isEmpty } ?? false) ||
                  (item.bonusSpellSaveDc.map { !$0.isEmpty } ?? false) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Magical Properties")
                    .font(.custom("Cinzel-Regular", size: 30))
                    .tracking(2)
                    .foregroundStyle(Color.tomeCrimson)
                if let spellAtk = item.bonusSpellAttack, !spellAtk.isEmpty {
                    ItemDetailRow(label: "Spell Attack", value: "\(spellAtk)")
                }
                if let spellDc = item.bonusSpellSaveDc, !spellDc.isEmpty {
                    ItemDetailRow(label: "Spell Save DC", value: "\(spellDc)")
                }
                DecorativeRuleView()
            }
        }
        
        // Wondrous
        if let wondrous = item.wondrous {
            ItemDetailRow(label: "Wondrous", value: "\(wondrous)")
            DecorativeRuleView()
        }

        // Attune
        if let attune = item.reqAttune, !attune.isEmpty {
            ItemDetailRow(label: "Attunement", value: "\(attune)")
            DecorativeRuleView()
        }
    }

    private struct ItemDetailRow: View {
        let label: String
        let value: String
        var body: some View {
            HStack {
                Text(label)
                    .font(.custom("Cinzel-Regular", size: 20))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeMuted)
                Spacer()
                Text(value)
                    .font(.custom("IMFellEnglish-Regular", size: 23))
                    .foregroundStyle(Color.tomeParchmentLight)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        ItemDetailView(item: ItemModel(
//            id: "1",
//            name: "Longsword",
//            type: "Weapon",
//            rarity: "Common",
//            description: "A standard longsword.",
//            isMagic: false
//        ))
//    }
//}
