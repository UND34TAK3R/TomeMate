//
//  BestiaryDetailView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct BestiaryDetailView: View {
    let creature: CreatureModel
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
                        Text(creature.name)
                            .font(.custom("Cinzel-Regular", size: 35))
                            .foregroundStyle(Color.tomeGoldLight)
                        Text([creature.size, creature.type.capitalized, creature.subtype.map { "(\($0))" }]
                                .compactMap { $0 }.joined(separator: " "))
                            .font(.custom("IMFellEnglish-Regular", size: 20))
                            .italic()
                            .foregroundStyle(Color.tomeGoldDim)
                        Text(creature.alignment.capitalized)
                            .font(.custom("IMFellEnglish-Regular", size: 20))
                            .italic()
                            .foregroundStyle(Color.tomeGold)
                    }
                    .fadeUp(appeared, delay: 0.05)
                    
                    DecorativeRuleView()
                    
                    // MARK: Core Stats
                    HStack(spacing: 0) {
                        BestiaryStatPill(label: "HP", value: creature.hit_dice.map { "\(creature.hit_points) (\($0))" } ?? "\(creature.hit_points)")
                        BestiaryStatPill(label: "AC", value: "\(creature.armor_class)")
                        BestiaryStatPill(label: "CR", value: creature.challenge_rating)
                        if let speed = creature.speed {
                            BestiaryStatPill(label: "Speed", value: speed)
                            }
                    }
                    .fadeUp(appeared, delay: 0.1)

                    DecorativeRuleView()

                    // MARK: Ability Scores
                    if creature.strength != nil {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "Ability Scores")
                                HStack(spacing: 0) {
                                    AbilityScoreCell(label: "STR", score: creature.strength)
                                    AbilityScoreCell(label: "DEX", score: creature.dexterity)
                                    AbilityScoreCell(label: "CON", score: creature.constitution)
                                    AbilityScoreCell(label: "INT", score: creature.intelligence)
                                    AbilityScoreCell(label: "WIS", score: creature.wisdom)
                                    AbilityScoreCell(label: "CHA", score: creature.charisma)
                                }
                            }
                            .fadeUp(appeared, delay: 0.15)

                    DecorativeRuleView()
                                        }

                    // MARK: Traits
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeader(title: "Traits")
                        if let senses = creature.senses, !senses.isEmpty {
                            CreatureTraitRow(label: "Senses", value: senses)
                        }
                        if let languages = creature.languages, !languages.isEmpty {
                            CreatureTraitRow(label: "Languages", value: languages)
                            }
                        }
                        .fadeUp(appeared, delay: 0.2)

                        // MARK: Resistances & Immunities
                        let hasDefenses = [creature.damage_resistances, creature.damage_immunities, creature.damage_vulnerabilities, creature.condition_immunities].contains(where: { $0 != nil && !($0!.isEmpty) })

                        if hasDefenses {
                            DecorativeRuleView()
                            VStack(alignment: .leading, spacing: 8) {
                                SectionHeader(title: "Defenses")
                                if let res = creature.damage_resistances, !res.isEmpty {
                                    CreatureTraitRow(label: "Resistances", value: res)
                                } else {
                                    CreatureTraitRow(label: "Resistances", value: "-")
                                }
                                if let imm = creature.damage_immunities, !imm.isEmpty {
                                    CreatureTraitRow(label: "Immunities", value: imm)
                                } else {
                                    CreatureTraitRow(label: "Immunities", value: "-")
                                }
                                if let vuln = creature.damage_vulnerabilities, !vuln.isEmpty {
                                    CreatureTraitRow(label: "Vulnerabilities", value: vuln)
                                } else {
                                    CreatureTraitRow(label: "Vulnerabilities", value: "-")
                                }
                                if let cond = creature.condition_immunities, !cond.isEmpty {
                                    CreatureTraitRow(label: "Condition Immunities", value: cond)
                                } else {
                                    CreatureTraitRow(label: "Condition Immunities", value: "-")
                                }
                            }
                            .fadeUp(appeared, delay: 0.25)
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
    }

    // MARK: – Subviews

    private struct SectionHeader: View {
        let title: String
        var body: some View {
            Text(title)
                .font(.custom("Cinzel-Regular", size: 35))
                .tracking(2)
                .foregroundStyle(Color.tomeCrimson)
        }
    }

    private struct CreatureTraitRow: View {
        let label: String
        let value: String
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.custom("Cinzel-Regular", size: 17))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeMuted)
                Text(value.capitalized)
                    .font(.custom("IMFellEnglish-Regular", size: 20))
                    .foregroundStyle(Color.tomeParchmentLight)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private struct AbilityScoreCell: View {
        let label: String
        let score: Int?

        private func modifier(_ score: Int) -> String {
            let mod = (score - 10) / 2
            return mod >= 0 ? "+\(mod)" : "\(mod)"
        }

        var body: some View {
            VStack(spacing: 2) {
                    Text(label)
                        .font(.custom("Cinzel-Regular", size: 13))
                        .tracking(1)
                        .foregroundStyle(Color.tomeMuted)
                    if let score = score {
                        Text("\(score)")
                            .font(.custom("Cinzel-Regular", size: 18))
                            .foregroundStyle(Color.tomeGoldLight)
                        Text(modifier(score))
                            .font(.custom("IMFellEnglish-Regular", size: 15))
                            .italic()
                            .foregroundStyle(Color.tomeParchment)
                    } else {
                        Text("—")
                            .font(.custom("Cinzel-Regular", size: 18))
                            .foregroundStyle(Color.tomeGoldLight)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.tomeParchment.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color.tomeSepia.opacity(0.2), lineWidth: 0.8)
                )
                .cornerRadius(2)
                .padding(2)
            }
        }

        private struct BestiaryStatPill: View {
            let label: String
            let value: String
            var body: some View {
                VStack(spacing: 4) {
                    Text(value)
                        .font(.custom("Cinzel-Regular", size: 18))
                        .foregroundStyle(Color.tomeMuted)
                        .multilineTextAlignment(.center)
                    Text(label)
                        .font(.custom("Cinzel-Regular", size: 15))
                        .tracking(1.5)
                        .foregroundStyle(Color.tomeParchmentLight)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.tomeParchment.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color.tomeSepia.opacity(0.2), lineWidth: 0.8)
                )
                .cornerRadius(2)
                .padding(2)
            }
        }

//#Preview {
//    NavigationStack {
//        BestiaryDetailView(creature: CreatureModel(
//            id: "1",
//            name: "Aboleth",
//            size: "Large",
//            type: "aberration",
//            alignment: "lawful evil",
//            armor_class: 17,
//            hit_points: 135,
//            challenge_rating: "10"
//        ))
//    }
//}
