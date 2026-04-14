//
//  HomebrewItemsView.swift
//  TomeMate
//
//  Created by NRD on 30/03/2026.
//

import SwiftUI
import CoreData

struct HomebrewItemsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let character: Character?

    @StateObject private var viewModel = ItemLookupViewModel()

    @State private var name = ""
    @State private var itemDescription = ""
    @State private var isMagic = false
    @State private var reqAttune = false
    @State private var armorClass = ""
    @State private var damageType = ""
    @State private var damageSeverity = ""

    var canCreate: Bool {
        !name.isEmpty && viewModel.selectedType != nil && viewModel.selectedRarity != nil
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 6) {
                        Text("New Homebrew Item")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView().padding(.horizontal, 60)
                    }
                    .padding(.vertical, 16)

                    // Basic Info
                    HomebrewSection(title: "Basic Info", icon: "bag") {
                        HomebrewTextField(label: "Item Name", icon: "textformat", placeholder: "Enter item name", text: $name)
                        tomeHairline
                        HomebrewTextEditor(label: "Description", icon: "text.alignleft", placeholder: "Describe the item...", text: $itemDescription)
                    }

                    // Properties
                    HomebrewSection(title: "Properties", icon: "list.bullet") {
                        HomebrewPicker(label: "Type", icon: "tag") {
                            Picker("", selection: $viewModel.selectedType) {
                                Text("Select").tag(String?.none)
                                ForEach(viewModel.homebrewTypeOptions, id: \.self) { type in
                                    Text(type).tag(String?.some(type))
                                }
                            }
                        }
                        tomeHairline
                        HomebrewPicker(label: "Rarity", icon: "star") {
                            Picker("", selection: $viewModel.selectedRarity) {
                                Text("Select").tag(String?.none)
                                ForEach(viewModel.rarityOptions, id: \.self) { rarity in
                                    Text(rarity.capitalized).tag(String?.some(rarity))
                                }
                            }
                        }
                        tomeHairline
                        HomebrewToggleRow(label: "Magic Item", icon: "sparkles", value: $isMagic)
                        tomeHairline
                        HomebrewToggleRow(label: "Requires Attunement", icon: "link.circle", value: $reqAttune)
                    }

                    // Conditional — Armor
                    if viewModel.selectedType == "Armor" {
                        HomebrewSection(title: "Armor Details", icon: "shield") {
                            HomebrewTextField(label: "Armor Class", icon: "number", placeholder: "e.g. 14", text: $armorClass)
                        }
                    }

                    // Conditional — Weapon
                    if viewModel.selectedType == "Weapon" {
                        HomebrewSection(title: "Damage Details", icon: "burst") {
                            HomebrewTextField(label: "Damage Type", icon: "bolt", placeholder: "e.g. slashing", text: $damageType)
                            tomeHairline
                            HomebrewTextField(label: "Damage Severity", icon: "flame", placeholder: "e.g. 1d8", text: $damageSeverity)
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
                SealButton("Create Item", isLoading: false, action: saveHomebrewItem)
                    .disabled(!canCreate)
                    .opacity(canCreate ? 1 : 0.5)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
                    .background(Color.tomeBg)
            }
        }
        .navigationTitle("Homebrew Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var tomeHairline: some View {
        Rectangle()
            .fill(Color.tomeSepia.opacity(0.2))
            .frame(height: 0.8)
            .padding(.leading, 16)
    }

    private func saveHomebrewItem() {
        let newItem = Item(context: viewContext)
        newItem.id = UUID().uuidString
        newItem.name = name
        newItem.desc = itemDescription
        newItem.type = viewModel.selectedType
        newItem.rarity = viewModel.selectedRarity
        newItem.isMagic = isMagic
        newItem.isHomebrew = true
        newItem.reqAttune = reqAttune
        if let character { newItem.addToCharacter(character) }
        try? viewContext.save()
        dismiss()
    }
}

#Preview {
    HomebrewItemsView(character: nil)
}
