//
//  CharacterSpellDetailView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-22.
//

import SwiftUI

struct CharacterSpellDetailView: View {
    let spell: Spell
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(spell.name ?? "")
                            .font(.custom("Cinzel-Regular", size: 35))
                            .foregroundStyle(Color.tomeGoldLight)

                        DecorativeRuleView()

                        Text("\(ordinal(spell.level)) \((spell.school ?? "").capitalized)")
                            .font(.custom("IMFellEnglish-Italic", size: 20))
                            .foregroundStyle(Color.tomeGoldDim)

                        if let castTime = spell.castTime {
                            HStack {
                                Text("Casting Type: ")
                                    .font(.custom("IMFellEnglish-Regular", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                                Text(castTime)
                                    .font(.custom("IMFellEnglish-Regular", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                            }
                        }

                        HStack {
                            Text("Range: ")
                                .font(.custom("IMFellEnglish-Italic", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                            Text("\(spell.range_type?.capitalized ?? "—")\(spell.range_amount != 0 ? " — \(spell.range_amount) ft" : "")")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                        }

                        if let components = spell.components, !components.isEmpty {
                            HStack {
                                Text("Components: ")
                                    .font(.custom("IMFellEnglish-Italic", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                                Text(components.joined(separator: ", ").uppercased())
                                    .font(.custom("IMFellEnglish-Regular", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                            }
                        }

                        if spell.is_concentration {
                            HStack {
                                Text("Duration: ")
                                    .font(.custom("IMFellEnglish-Italic", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                                Text("Concentration")
                                    .font(.custom("IMFellEnglish-Regular", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                            }
                        }

                        if let damage = spell.damage_type, !damage.isEmpty {
                            Text("Damage Type: \(damage.capitalized)")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                        }
                        if let save = spell.saving_throw_type, !save.isEmpty {
                            Text("Saving Throw: \(save.capitalized)")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                        }
                        if let conditions = spell.condition_type, !conditions.isEmpty {
                            Text("Condition: \(conditions.joined(separator: ", "))")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                        }
                    }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    // MARK: - Description
                    if let desc = spell.desc, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Cinzel-Regular", size: 30))
                                .tracking(2)
                                .foregroundStyle(Color.tomeCrimson)
                            Text(desc)
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .fadeUp(appeared, delay: 0.1)
                    }

                    DecorativeRuleView()
                }
                .padding(24)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
    }
}

private func ordinal(_ level: Int16) -> String {
    switch level {
    case 0: return "Cantrip"
    case 1: return "1st-level"
    case 2: return "2nd-level"
    case 3: return "3rd-level"
    default: return "\(level)th-level"
    }
}

#Preview {
  //  CharacterSpellDetailView()
}
