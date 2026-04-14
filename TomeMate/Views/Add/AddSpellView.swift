//
//  AddSpellView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-31.
//

import SwiftUI
import CoreData

struct AddSpellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let character: Character?

    @StateObject private var viewModel = SpellLookupViewModel()

    @State private var showingFilters = false
    @State private var addedSpellIDs: Set<String> = []
    @State private var confirmSpell: SpellModel? = nil

    private var existingSpellIDs: Set<String> {
        let set = character?.spells as? Set<Spell> ?? []
        return Set(set.compactMap(\.name))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.tomeBg.ignoresSafeArea()

                VStack(spacing: 0) {
                    TomeSearchBar(placeholder: "Search spells…", text: $viewModel.searchText)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)

                    if viewModel.hasActiveFilters {
                        activeFilterChips
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                    }

                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.3), .clear],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(height: 0.8)
                        .padding(.top, 10)

                    if viewModel.isLoading && viewModel.spells.isEmpty {
                        TomeLoadingView()
                    } else if viewModel.spells.isEmpty {
                        TomeEmptyStateView(message: "No spells found.\nTry adjusting your search or filters.")
                    } else {
                        spellList
                    }
                }
            }
            .navigationTitle("Add Spell")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .font(.custom("Cinzel-Regular", size: 12))
                        .foregroundStyle(Color.tomeGold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingFilters = true } label: {
                        Image(systemName: viewModel.hasActiveFilters
                              ? "line.3.horizontal.decrease.circle.fill"
                              : "line.3.horizontal.decrease.circle")
                            .foregroundColor(.tomeGold)
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                SpellFilterSheet(viewModel: viewModel)
            }
            .confirmationDialog(
                confirmSpell.map { "Add \($0.name) to \(character?.name ?? "character")?" } ?? "",
                isPresented: Binding(get: { confirmSpell != nil }, set: { if !$0 { confirmSpell = nil } }),
                titleVisibility: .visible
            ) {
                Button("Add Spell") { if let spell = confirmSpell { addSpell(spell) } }
                Button("Cancel", role: .cancel) { confirmSpell = nil }
            }
        }
    }

    // MARK: - Active filter chips

    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let lvl = viewModel.selectedLevel {
                    TomeActiveFilterChip(label: lvl == 0 ? "Cantrip" : "Level \(lvl)") { viewModel.selectedLevel = nil }
                }
                if let school = viewModel.selectedSchool {
                    TomeActiveFilterChip(label: school.capitalized) { viewModel.selectedSchool = nil }
                }
                if let conc = viewModel.selectedConcentration {
                    TomeActiveFilterChip(label: conc ? "Concentration" : "No Conc.") { viewModel.selectedConcentration = nil }
                }
                if let dmg = viewModel.selectedDamageType {
                    TomeActiveFilterChip(label: dmg.capitalized) { viewModel.selectedDamageType = nil }
                }
                if let cast = viewModel.selectedCastTime {
                    TomeActiveFilterChip(label: cast.capitalized) { viewModel.selectedCastTime = nil }
                }
                Button("Clear all") { viewModel.clearFilters() }
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(1)
                    .foregroundStyle(Color.tomeCrimsonLight)
            }
        }
    }

    // MARK: - List

    private var spellList: some View {
        List {
            ForEach(viewModel.spells) { spell in
                spellRow(for: spell)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func spellRow(for spell: SpellModel) -> some View {
        let alreadyAdded = existingSpellIDs.contains(spell.name) || addedSpellIDs.contains(spell.name)

        Button {
            guard !alreadyAdded else { return }
            confirmSpell = spell
        } label: {
            HStack(spacing: 12) {
                Rectangle()
                    .fill(alreadyAdded ? Color.tomeSepia.opacity(0.3) : Color.tomeCrimson.opacity(0.6))
                    .frame(width: 2)
                    .cornerRadius(1)
                    .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(spell.name)
                        .font(.custom("Cinzel-Regular", size: 13))
                        .foregroundStyle(alreadyAdded ? Color.tomeSepia.opacity(0.5) : Color.tomeInk)
                        .lineLimit(1)
                    HStack(spacing: 5) {
                        Text(spell.school.capitalized)
                            .foregroundStyle(Color.tomeCrimsonLight)
                        Text("·").foregroundStyle(Color.tomeSepia.opacity(0.4))
                        Text(spell.level == 0 ? "Cantrip" : "Level \(spell.level)")
                            .foregroundStyle(Color.tomeParchmentText)
                        if spell.is_concentration {
                            Text("· Conc.")
                                .foregroundStyle(Color.tomeSepia)
                        }
                    }
                    .font(.custom("IMFellEnglish-Regular", size: 11))
                    .italic()
                }

                Spacer()

                if alreadyAdded {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.tomeGold.opacity(0.5))
                        .font(.system(size: 16))
                } else {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Color.tomeGold)
                        .font(.system(size: 16))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .listRowBackground(rowBackground)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.tomeParchment.opacity(0.5))
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.18), lineWidth: 0.8))
            .padding(.vertical, 2)
    }

    // MARK: - Save

    private func addSpell(_ spell: SpellModel) {
        let newSpell = Spell(context: viewContext)
        newSpell.spellId = UUID()
        newSpell.name = spell.name
        newSpell.level = spell.level
        newSpell.school = spell.school
        newSpell.castTime = spell.cast_time
        newSpell.range_type = spell.range_type
        newSpell.is_concentration = spell.is_concentration
        newSpell.desc = spell.description
        newSpell.materials = spell.material
        newSpell.isHomebrew = false
        if let character { newSpell.addToCharacter(character) }
        try? viewContext.save()
        addedSpellIDs.insert(spell.id)
        confirmSpell = nil
    }
}

// MARK: - Filter sheet

private struct SpellFilterSheet: View {
    @ObservedObject var viewModel: SpellLookupViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                // Sheet header
                HStack {
                    Text("Filter Spells")
                        .font(.custom("Cinzel-Regular", size: 18))
                        .foregroundStyle(Color.tomeParchment)
                    Spacer()
                    Button { dismiss() } label: {
                        Text("Done")
                            .font(.custom("Cinzel-Regular", size: 12))
                            .tracking(1)
                            .foregroundStyle(Color.tomeGold)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 14)

                Rectangle()
                    .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.3), .clear],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(height: 0.8)
                    .padding(.horizontal, 20)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        FilterPickerSection(title: "Level", icon: "number") {
                            Picker("", selection: $viewModel.selectedLevel) {
                                Text("Any").tag(Int16?.none)
                                ForEach(viewModel.levelOptions, id: \.self) { lvl in
                                    Text(lvl == 0 ? "Cantrip" : "Level \(lvl)").tag(Int16?.some(lvl))
                                }
                            }
                        }
                        FilterPickerSection(title: "School", icon: "book.closed") {
                            Picker("", selection: $viewModel.selectedSchool) {
                                Text("Any").tag(String?.none)
                                ForEach(viewModel.schoolOptions, id: \.self) { s in
                                    Text(s.capitalized).tag(String?.some(s))
                                }
                            }
                        }
                        FilterPickerSection(title: "Cast Time", icon: "clock") {
                            Picker("", selection: $viewModel.selectedCastTime) {
                                Text("Any").tag(String?.none)
                                ForEach(viewModel.castTimeOptions, id: \.self) { c in
                                    Text(c.capitalized).tag(String?.some(c))
                                }
                            }
                        }
                        FilterPickerSection(title: "Concentration", icon: "circles.hexagonpath") {
                            Picker("", selection: $viewModel.selectedConcentration) {
                                Text("Any").tag(Bool?.none)
                                Text("Required").tag(Bool?.some(true))
                                Text("Not Required").tag(Bool?.some(false))
                            }
                        }

                        // Clear button
                        Button {
                            viewModel.clearFilters()
                            dismiss()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 12, weight: .light))
                                Text("Clear All Filters")
                                    .font(.custom("Cinzel-Regular", size: 11))
                                    .tracking(1)
                            }
                            .foregroundStyle(Color.tomeCrimsonLight)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.tomeCrimson.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeCrimson.opacity(0.25), lineWidth: 0.8))
                            .cornerRadius(3)
                        }
                        .buttonStyle(TomeButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: - Shared filter picker section

struct FilterPickerSection<Content: View>: View {
    let title: String
    let icon: String
    let picker: () -> Content

    init(title: String, icon: String, @ViewBuilder picker: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.picker = picker
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(Color.tomeSepia)
                .frame(width: 16)
            Text(title)
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .foregroundStyle(Color.tomeParchment)
            Spacer()
            picker()
                .tint(Color.tomeGold)
                .font(.custom("IMFellEnglish-Regular", size: 13))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }
}

#Preview { AddSpellView(character: nil) }
