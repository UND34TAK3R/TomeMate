//
//  SpellDetailView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct SpellDetailView: View {
    let spell: SpellModel
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
                        Text(spell.name)
                            .font(.custom("Cinzel-Regular", size: 35))
                            .foregroundStyle(Color.tomeGoldLight)
                        
                        DecorativeRuleView()
                        
                        Text("\(ordinal(spell.level)) \(spell.school.capitalized)")                  .font(.custom("IMFellEnglish-Italic", size: 20))
                            .foregroundStyle(Color.tomeGoldDim)
                        HStack {
                            Text("Casting Type: ")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                            Text("\(spell.cast_time)")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                        }
                        HStack {
                            Text("Range: ")
                                .font(.custom("IMFellEnglish-Italic", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                            Text("\(spell.range_type.capitalized)\(spell.range_amount.map { " — \($0) \(spell.range_unit ?? "")" } ?? "")")
                                .font(Font.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                        }
                        HStack {
                            Text("Components: ")
                                .font(.custom("IMFellEnglish-Italic", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                            Text("\(spell.components.isEmpty ? "None" : spell.components.joined(separator: ", "))")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeGoldDim)
                        }
                        if let amount = spell.durationAmount, let unit = spell.spell_duration_unit {
                            HStack {
                                Text("Duration: ")
                                    .font(.custom("IMFellEnglish-Italic", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                                Text("\(spell.is_concentration ? "Concentration, up to " : "")\(amount) \(unit)(s)")
                                    .font(.custom("IMFellEnglish-Regular", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                            }
                        } else {
                            HStack {
                                Text("Duration: ")
                                    .font(.custom("IMFellEnglish-Italic", size: 20))
                                    .foregroundStyle(Color.tomeSepia)
                                Text("\(spell.durationType.capitalized)")
                                    .font(.custom("IMFellEnglish-Regular", size: 20))
                                    .foregroundStyle(Color.tomeGoldDim)
                            }
                        }
                        
                        // For damage calculations
                        if let damage = spell.damage_type {
                            Text("Damage Type: \(damage.capitalized)")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                        }
                        if let save = spell.saving_throw_type {
                            Text("Saving Throw: \(save.capitalized)")
                                .font(.custom("IMFellEnglish-Regular", size: 20))
                                .foregroundStyle(Color.tomeSepia)
                        }
                                        }
                    .fadeUp(appeared, delay: 0.05)

                    DecorativeRuleView()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.custom("Cinzel-Regular", size: 30))
                            .tracking(2)
                            .foregroundStyle(Color.tomeCrimson)
                        Text(cleanDescription(spell.description))
                            .font(.custom("IMFellEnglish-Regular", size: 20))
                            .foregroundStyle(Color.tomeSepia)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .fadeUp(appeared, delay: 0.1)

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


private struct SpellDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(label):")
                .font(.custom("Cinzel-Regular", size: 10))
                .tracking(0.5)
                .foregroundStyle(Color.tomeInk)
            Text(value)
                .font(.custom("IMFellEnglish-Regular", size: 12))
                .italic()
                .foregroundStyle(Color.tomeSepia)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// -- MARK: Helper Methods
private func ordinal(_ level: Int16) -> String {
    switch level {
    case 0: return "Cantrip"
    case 1: return "1st-level"
    case 2: return "2nd-level"
    case 3: return "3rd-level"
    default: return "\(level)th-level"
    }
}

private func cleanDescription(_ raw: String) -> String {
    var text = raw
    let pattern = #"\{@\w+\s([^}]+)\}"#
    if let regex = try? NSRegularExpression(pattern: pattern) {
        let range = NSRange(text.startIndex..., in: text)
        text = regex.stringByReplacingMatches(in: text, range: range, withTemplate: "$1")
    }
    return text
}

#Preview {
    //SpellDetailView()
}
