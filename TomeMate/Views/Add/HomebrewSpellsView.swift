//
//  HomebrewSpellsView.swift
//  TomeMate
//
//  Created by NRD on 30/03/2026.
//

import SwiftUI
import CoreData

struct HomebrewSpellsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let character: Character?

    @StateObject private var viewModel = SpellLookupViewModel()

    @State private var name = ""
    @State private var description = ""
    @State private var materialText = ""
    @State private var isRanged = false
    @State private var rangeAmount = ""
    @State private var selectedComponents: Set<String> = []

    var canCreate: Bool {
        !name.isEmpty && viewModel.selectedLevel != nil && viewModel.selectedSchool != nil
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 6) {
                        Text("New Homebrew Spell")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView().padding(.horizontal, 60)
                    }
                    .padding(.vertical, 16)

                    // Basic Info
                    HomebrewSection(title: "Basic Info", icon: "scroll") {
                        HomebrewTextField(label: "Spell Name", icon: "textformat", placeholder: "Enter spell name", text: $name)
                        tomeHairline
                        HomebrewTextEditor(label: "Description", icon: "text.alignleft", placeholder: "Describe the spell's effects...", text: $description)
                    }

                    // Spell Properties
                    HomebrewSection(title: "Spell Properties", icon: "sparkles") {
                        HomebrewPicker(label: "Level", icon: "number") {
                            Picker("", selection: $viewModel.selectedLevel) {
                                Text("Select").tag(Int16?.none)
                                ForEach(viewModel.levelOptions, id: \.self) { level in
                                    Text(level == 0 ? "Cantrip" : "Level \(level)").tag(Int16?.some(level))
                                }
                            }
                        }
                        tomeHairline
                        HomebrewPicker(label: "School", icon: "book.closed") {
                            Picker("", selection: $viewModel.selectedSchool) {
                                Text("Select").tag(String?.none)
                                ForEach(viewModel.schoolOptions, id: \.self) { school in
                                    Text(school.capitalized).tag(String?.some(school))
                                }
                            }
                        }
                        tomeHairline
                        HomebrewToggleRow(label: "Requires Concentration", icon: "circles.hexagonpath",
                            value: Binding(
                                get: { viewModel.selectedConcentration ?? false },
                                set: { viewModel.selectedConcentration = $0 }
                            )
                        )
                    }

                    // Casting & Range
                    HomebrewSection(title: "Casting & Range", icon: "wand.and.stars") {
                        HomebrewPicker(label: "Cast Time", icon: "clock") {
                            Picker("", selection: $viewModel.selectedCastTime) {
                                Text("Select").tag(String?.none)
                                ForEach(viewModel.castTimeOptions, id: \.self) { time in
                                    Text(time).tag(String?.some(time))
                                }
                            }
                        }
                        tomeHairline
                        HomebrewToggleRow(label: "Ranged", icon: "arrow.up.right.circle",
                            value: Binding(
                                get: { isRanged },
                                set: { newVal in
                                    isRanged = newVal
                                    if !newVal { rangeAmount = "Touch" }
                                }
                            )
                        )
                        if isRanged {
                            tomeHairline
                            HomebrewPicker(label: "Range Type", icon: "scope") {
                                Picker("", selection: $viewModel.selectedRangeType) {
                                    Text("Select").tag(String?.none)
                                    ForEach(viewModel.rangeTypeOptions, id: \.self) { range in
                                        Text(range).tag(String?.some(range))
                                    }
                                }
                            }
                            tomeHairline
                            HomebrewTextField(label: "Range Amount", icon: "ruler", placeholder: "e.g. 60", text: $rangeAmount)
                        }
                    }

                    // Components
                    HomebrewSection(title: "Components", icon: "flask") {
                        ForEach(["Verbal", "Somatic", "Material"], id: \.self) { component in
                            let isOn = selectedComponents.contains(component)
                            Button {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    if isOn { selectedComponents.remove(component) }
                                    else    { selectedComponents.insert(component) }
                                }
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(isOn ? Color.tomeGold : Color.tomeSepia.opacity(0.4), lineWidth: 1)
                                            .frame(width: 20, height: 20)
                                        if isOn {
                                            Circle().fill(Color.tomeGold).frame(width: 12, height: 12)
                                        }
                                    }
                                    Text(component)
                                        .font(.custom("IMFellEnglish-Regular", size: 14))
                                        .foregroundStyle(isOn ? Color.tomeParchment : Color.tomeMuted)
                                    Spacer()
                                    if isOn {
                                        Text(component == "Verbal" ? "V" : component == "Somatic" ? "S" : "M")
                                            .font(.custom("Cinzel-Bold", size: 11))
                                            .foregroundStyle(Color.tomeGold)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(TomeButtonStyle())
                            if component != "Material" { tomeHairline }
                        }
                        if selectedComponents.contains("Material") {
                            tomeHairline
                            HomebrewTextField(label: "Material", icon: "bag", placeholder: "e.g. a pinch of sand", text: $materialText)
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }

            // Save button
            VStack(spacing: 0) {
                LinearGradient(colors: [Color.tomeBg.opacity(0), Color.tomeBg], startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
                SealButton("Create Spell", isLoading: false, action: saveHomebrewSpell)
                    .disabled(!canCreate)
                    .opacity(canCreate ? 1 : 0.5)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
                    .background(Color.tomeBg)
            }
        }
        .navigationTitle("Homebrew Spell")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var tomeHairline: some View {
        Rectangle()
            .fill(Color.tomeSepia.opacity(0.2))
            .frame(height: 0.8)
            .padding(.leading, 16)
    }

    private func saveHomebrewSpell() {
        let newSpell = Spell(context: viewContext)
        newSpell.spellId = UUID()
        newSpell.name = name
        newSpell.level = viewModel.selectedLevel ?? 0
        newSpell.school = viewModel.selectedSchool
        newSpell.castTime = viewModel.selectedCastTime
        newSpell.is_concentration = viewModel.selectedConcentration ?? false
        newSpell.desc = description
        newSpell.isHomebrew = true
        newSpell.components = selectedComponents.map {
            switch $0 {
            case "Verbal": return "v"
            case "Somatic": return "s"
            case "Material": return "m"
            default: return $0.lowercased()
            }
        }
        newSpell.materials = selectedComponents.contains("Material") ? materialText : nil
        if isRanged {
            newSpell.range_type = viewModel.selectedRangeType
            if let amount = Int16(rangeAmount) { newSpell.range_amount = amount }
        } else {
            newSpell.range_type = "touch"
            newSpell.range_amount = 0
        }
        if let character { newSpell.addToCharacter(character) }
        try? viewContext.save()
        dismiss()
    }
}

#Preview {
    HomebrewSpellsView(character: nil)
}
