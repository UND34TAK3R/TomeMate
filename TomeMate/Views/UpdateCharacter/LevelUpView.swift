//
//  LevelUpView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct LevelUpView: View {
    let character: Character
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder

    @State private var selectedClass: Classes? = nil
    @State private var appeared = false

    private var classes: [Classes] {
        (character.classes as? Set<Classes> ?? []).sorted { ($0.name ?? "") < ($1.name ?? "") }
    }

    private var newLevel: Int16 { character.level + 1 }

    private var profBonusIncreases: Bool {
        [5, 9, 13, 17].contains(Int(newLevel))
    }

    private var hpIncrease: Int16 {
        guard let cls = selectedClass else { return 0 }
        return Int16(holder.calculateNewHp(character: character, selectedClass: cls)) - character.hp
    }

    private var newHpTotal: Int16 { character.hp + hpIncrease }
    private var newProfBonus: Int16 { character.proficiencyBonus + 1 }

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    heroBanner
                    classSelector
                    if selectedClass != nil {
                        changesSection
                    }
                    confirmButton
                }
                .padding(16)
                .animation(.spring(response: 0.35), value: selectedClass)
            }
        }
        .navigationTitle("Level Up")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MultiClassView(character: character).onDisappear { dismiss() }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 12, weight: .light))
                        Text("Multiclass")
                            .font(.custom("Cinzel-Regular", size: 10))
                            .tracking(1)
                    }
                    .foregroundStyle(Color.tomeGold)
                }
            }
        }
        .onAppear {
            appeared = true
            if classes.count == 1 { selectedClass = classes.first }
        }
    }

    // MARK: - Hero Banner
    private var heroBanner: some View {
        VStack(spacing: 10) {
            D20IconView()
                .frame(width: 64, height: 64)
                .opacity(0.8)

            Text("Level Up")
                .font(.custom("Cinzel-Regular", size: 26))
                .foregroundStyle(Color.tomeParchment)

            Text(character.name ?? "Unknown")
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .italic()
                .foregroundStyle(Color.tomeMuted)

            HStack(spacing: 8) {
                Text("Level \(character.level)")
                    .font(.custom("Cinzel-Regular", size: 11))
                    .foregroundStyle(Color.tomeMuted)
                Image(systemName: "arrow.right")
                    .font(.system(size: 9, weight: .light))
                    .foregroundStyle(Color.tomeSepia)
                Text("Level \(newLevel)")
                    .font(.custom("Cinzel-Bold", size: 13))
                    .foregroundStyle(Color.tomeGold)
            }

            DecorativeRuleView().padding(.horizontal, 60)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }

    // MARK: - Class Selector
    private var classSelector: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color.tomeCrimson.opacity(0.7))
                    .frame(width: 2, height: 12).cornerRadius(1)
                Text("Which class levels up?".uppercased())
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(2)
                    .foregroundStyle(Color.tomeMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tomeSpine)

            VStack(spacing: 0) {
                ForEach(Array(classes.enumerated()), id: \.element) { index, cls in
                    classRow(cls)
                    if index < classes.count - 1 {
                        Rectangle()
                            .fill(Color.tomeSepia.opacity(0.2))
                            .frame(height: 0.8)
                            .padding(.leading, 16)
                    }
                }
            }
        }
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }

    private func classRow(_ cls: Classes) -> some View {
        let isSelected = selectedClass == cls
        return Button {
            withAnimation(.spring(response: 0.3)) { selectedClass = cls }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Color.tomeGold : Color.tomeSepia.opacity(0.4), lineWidth: 1)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle().fill(Color.tomeGold).frame(width: 12, height: 12)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: isSelected)

                VStack(alignment: .leading, spacing: 2) {
                    Text(cls.name ?? "Unknown")
                        .font(.custom("Cinzel-Regular", size: 13))
                        .foregroundStyle(isSelected ? Color.tomeParchment : Color.tomeMuted)
                    Text("Currently level \(cls.level)")
                        .font(.custom("IMFellEnglish-Regular", size: 11))
                        .italic()
                        .foregroundStyle(Color.tomeSepia)
                }
                Spacer()
                if isSelected {
                    Text("Selected")
                        .font(.custom("Cinzel-Regular", size: 9))
                        .tracking(1)
                        .foregroundStyle(Color.tomeGold)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.tomeGold.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeGold.opacity(0.3), lineWidth: 0.7))
                        .cornerRadius(2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(isSelected ? Color.tomeGold.opacity(0.05) : Color.clear)
        }
        .buttonStyle(TomeButtonStyle())
    }

    // MARK: - Changes Section
    private var changesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color.tomeGold.opacity(0.7))
                    .frame(width: 2, height: 12).cornerRadius(1)
                Text("New Changes".uppercased())
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(2)
                    .foregroundStyle(Color.tomeMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tomeSpine)

            VStack(spacing: 0) {
                TomeLevelChangeRow(icon: "arrow.up.circle.fill", accentColor: .tomeGold,
                                   label: "Character Level",
                                   from: "\(character.level)", to: "\(newLevel)", delta: nil)
                tomeHairline
                TomeLevelChangeRow(icon: "shield.fill", accentColor: .tomeSepia,
                                   label: "\(selectedClass?.name ?? "Class") Level",
                                   from: "\(selectedClass?.level ?? 0)", to: "\((selectedClass?.level ?? 0) + 1)", delta: nil)
                tomeHairline
                TomeLevelChangeRow(icon: "heart.fill", accentColor: .tomeCrimson,
                                   label: "Hit Points",
                                   from: "\(character.hp)", to: "\(newHpTotal)",
                                   delta: hpIncrease > 0 ? "+\(hpIncrease)" : "\(hpIncrease)")
                if profBonusIncreases {
                    tomeHairline
                    TomeLevelChangeRow(icon: "star.fill", accentColor: .tomeGoldLight,
                                       label: "Proficiency Bonus",
                                       from: "+\(character.proficiencyBonus)", to: "+\(newProfBonus)", delta: "+1")
                }
            }
        }
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private var tomeHairline: some View {
        Rectangle()
            .fill(Color.tomeSepia.opacity(0.2))
            .frame(height: 0.8)
            .padding(.leading, 52)
    }

    // MARK: - Confirm Button
    private var confirmButton: some View {
        SealButton(selectedClass == nil ? "Select a Class First" : "Confirm Level Up", isLoading: false) {
            guard let cls = selectedClass else { return }
            holder.levelUp(character: character, selectedClass: cls, context)
            dismiss()
        }
        .disabled(selectedClass == nil)
        .opacity(selectedClass == nil ? 0.5 : 1)
    }
}

// MARK: - Change Row
private struct TomeLevelChangeRow: View {
    let icon: String
    let accentColor: Color
    let label: String
    let from: String
    let to: String
    let delta: String?

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(accentColor)
                .frame(width: 24)

            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 13))
                .foregroundStyle(Color.tomeParchment)

            Spacer()

            HStack(spacing: 6) {
                Text(from)
                    .font(.custom("Cinzel-Regular", size: 12))
                    .foregroundStyle(Color.tomeMuted)
                Image(systemName: "arrow.right")
                    .font(.system(size: 8, weight: .light))
                    .foregroundStyle(Color.tomeSepia)
                Text(to)
                    .font(.custom("Cinzel-Bold", size: 13))
                    .foregroundStyle(Color.tomeParchment)
                if let delta {
                    Text(delta)
                        .font(.custom("Cinzel-Regular", size: 9))
                        .tracking(0.5)
                        .foregroundStyle(Color.tomeInk)
                        .padding(.horizontal, 6).padding(.vertical, 3)
                        .background(Color.tomeGold.opacity(0.85))
                        .cornerRadius(2)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }
}
