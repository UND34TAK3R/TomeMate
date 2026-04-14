//
//  UpdateCharacterView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct UpdateCharacterView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder

    let character: Character

    @State private var gold: Double
    @State private var inspiration: Double
    @State private var hitpoints: Double
    @State private var armorClass: Double
    @State private var speed: Double
    @State private var experience: Double
    @State private var age: Double
    @State private var initiative: Double
    @State private var passivePerception: Double
    @State private var alignment: String

    let alignments = [
        "Lawful Good", "Neutral Good", "Chaotic Good",
        "Lawful Neutral", "True Neutral", "Chaotic Neutral",
        "Lawful Evil", "Neutral Evil", "Chaotic Evil"
    ]

    init(character: Character) {
        self.character = character
        _gold              = State(initialValue: Double(character.gold))
        _inspiration       = State(initialValue: Double(character.inspiration))
        _hitpoints         = State(initialValue: Double(character.hp))
        _armorClass        = State(initialValue: Double(character.armorClass))
        _speed             = State(initialValue: Double(character.speed ?? "30") ?? 30)
        _experience        = State(initialValue: Double(character.experiencePoints))
        _age               = State(initialValue: Double(character.age))
        _initiative        = State(initialValue: Double(character.initiative))
        _passivePerception = State(initialValue: Double(character.passivePerception))
        _alignment         = State(initialValue: character.alignment ?? "True Neutral")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 6) {
                        Text(character.name ?? "Character")
                            .font(.custom("Cinzel-Regular", size: 22))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView()
                            .padding(.horizontal, 60)
                    }
                    .padding(.vertical, 20)

                    VStack(spacing: 16) {

                        // MARK: - Combat
                        TomeEditSection(title: "Combat") {
                            TomeStatRow(label: "Hit Points", value: $hitpoints, range: 0...999)
                            TomeStatRow(label: "Armor Class", value: $armorClass, range: 0...30)
                            TomeStatRow(label: "Initiative", value: $initiative, range: -10...20)
                            TomeStatRow(label: "Speed", value: $speed, range: 0...120, step: 5)
                            TomeStatRow(label: "Passive Perception", value: $passivePerception, range: 0...30)
                        }

                        // MARK: - Character Info
                        TomeEditSection(title: "Character Info") {
                            TomeStatRow(label: "Inspiration", value: $inspiration, range: 0...999)
                            TomeStatRow(label: "Age", value: $age, range: 0...999)
                            TomeGoldRow(label: "Gold", value: $gold)
                            if character.useXp {
                                TomeXpRow(label: "Experience", value: $experience)
                            }
                        }

                        // MARK: - Alignment
                        TomeEditSection(title: "Alignment") {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                ForEach(alignments, id: \.self) { option in
                                    Button {
                                        alignment = option
                                    } label: {
                                        Text(option)
                                            .font(.custom("IMFellEnglish-Regular", size: 11))
                                            .italic()
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(alignment == option ? Color.tomeCrimson : Color.tomeLeather)
                                            .foregroundColor(alignment == option ? Color.tomeParchment : Color.tomeMuted)
                                            .cornerRadius(2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 2)
                                                    .stroke(alignment == option ? Color.tomeCrimson : Color.tomeSepia.opacity(0.3), lineWidth: 0.8)
                                            )
                                    }
                                    .buttonStyle(TomeButtonStyle())
                                }
                            }
                            .padding(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }

            // Save button
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.tomeBg.opacity(0), Color.tomeBg],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 30)

                SealButton("Save Changes", isLoading: false) {
                    holder.updateCharacter(
                        character: character,
                        gold: gold,
                        inspiration: inspiration,
                        hitpoints: hitpoints,
                        armor_class: armorClass,
                        speed: speed,
                        experience: experience,
                        age: age,
                        initiative: initiative,
                        passive_perception: passivePerception,
                        alignement: alignment,
                        context
                    )
                    dismiss()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .background(Color.tomeBg)
            }
        }
        .navigationTitle("Edit Character")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Section wrapper
private struct TomeEditSection<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Rectangle()
                    .fill(Color.tomeCrimson.opacity(0.7))
                    .frame(width: 2, height: 12)
                    .cornerRadius(1)
                Text(title.uppercased())
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(2.5)
                    .foregroundStyle(Color.tomeMuted)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tomeSpine)

            content()
        }
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }
}

// MARK: - Stat Row
private struct TomeStatRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double = 1

    var body: some View {
        HStack {
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .foregroundStyle(Color.tomeParchment)
            Spacer()
            HStack(spacing: 14) {
                Button {
                    if value - step >= range.lowerBound { value -= step }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.tomeCrimsonLight)
                        .frame(width: 28, height: 28)
                        .background(Color.tomeSpine)
                        .cornerRadius(2)
                }
                Text("\(Int(value))")
                    .font(.custom("Cinzel-Regular", size: 16))
                    .foregroundStyle(Color.tomeGold)
                    .frame(minWidth: 36)
                    .multilineTextAlignment(.center)
                Button {
                    if value + step <= range.upperBound { value += step }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.tomeGold)
                        .frame(width: 28, height: 28)
                        .background(Color.tomeSpine)
                        .cornerRadius(2)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .overlay(Rectangle().fill(Color.tomeSepia.opacity(0.15)).frame(height: 0.8), alignment: .bottom)
    }
}

// MARK: - Gold Row
private struct TomeGoldRow: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.custom("IMFellEnglish-Regular", size: 14))
                    .foregroundStyle(Color.tomeParchment)
                Spacer()
                Text("\(Int(value)) gp")
                    .font(.custom("Cinzel-Regular", size: 14))
                    .foregroundStyle(Color.tomeGold)
            }
            HStack(spacing: 6) {
                TomeStepBtn(label: "-100", color: .tomeCrimsonLight) { value = max(0, value - 100) }
                TomeStepBtn(label: "-10",  color: .tomeCrimsonLight) { value = max(0, value - 10)  }
                TomeStepBtn(label: "-1",   color: .tomeCrimsonLight) { value = max(0, value - 1)   }
                Spacer()
                TomeStepBtn(label: "+1",   color: .tomeGold)         { value += 1   }
                TomeStepBtn(label: "+10",  color: .tomeGold)         { value += 10  }
                TomeStepBtn(label: "+100", color: .tomeGold)         { value += 100 }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .overlay(Rectangle().fill(Color.tomeSepia.opacity(0.15)).frame(height: 0.8), alignment: .bottom)
    }
}

// MARK: - XP Row
private struct TomeXpRow: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.custom("IMFellEnglish-Regular", size: 14))
                    .foregroundStyle(Color.tomeParchment)
                Spacer()
                Text("\(Int(value)) XP")
                    .font(.custom("Cinzel-Regular", size: 14))
                    .foregroundStyle(Color.tomeGoldLight)
            }
            HStack(spacing: 6) {
                TomeStepBtn(label: "-1k",  color: .tomeCrimsonLight) { value = max(0, value - 1000) }
                TomeStepBtn(label: "-100", color: .tomeCrimsonLight) { value = max(0, value - 100)  }
                TomeStepBtn(label: "-1",   color: .tomeCrimsonLight) { value = max(0, value - 1)    }
                Spacer()
                TomeStepBtn(label: "+1",   color: .tomeGold)         { value += 1    }
                TomeStepBtn(label: "+100", color: .tomeGold)         { value += 100  }
                TomeStepBtn(label: "+1k",  color: .tomeGold)         { value += 1000 }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

// MARK: - Step Button
private struct TomeStepBtn: View {
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Cinzel-Regular", size: 10))
                .tracking(0.5)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(color.opacity(0.12))
                .foregroundColor(color)
                .cornerRadius(2)
                .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(color.opacity(0.25), lineWidth: 0.8))
        }
        .buttonStyle(TomeButtonStyle())
    }
}

#Preview {
    
}
