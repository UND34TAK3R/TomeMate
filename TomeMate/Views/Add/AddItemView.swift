//
//  AddItemView.swift
//  TomeMate
//
import SwiftUI
import CoreData

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let character: Character?

    @StateObject private var viewModel = ItemLookupViewModel()

    @State private var showingFilters = false
    @State private var addedItemIDs: Set<String> = []
    @State private var confirmItem: ItemModel? = nil

    private var existingItemIDs: Set<String> {
        let set = character?.items as? Set<Item> ?? []
        return Set(set.compactMap(\.id))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.tomeBg.ignoresSafeArea()

                VStack(spacing: 0) {
                    TomeSearchBar(placeholder: "Search items…", text: $viewModel.searchText)
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

                    if viewModel.isLoading && viewModel.items.isEmpty {
                        TomeLoadingView()
                    } else if viewModel.items.isEmpty {
                        TomeEmptyStateView(message: "No items found.\nTry adjusting your search or filters.")
                    } else {
                        itemList
                    }
                }
            }
            .navigationTitle("Add Item")
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
                ItemFilterSheet(viewModel: viewModel)
            }
            .confirmationDialog(
                confirmItem.map { "Add \($0.name) to \(character?.name ?? "character")?" } ?? "",
                isPresented: Binding(get: { confirmItem != nil }, set: { if !$0 { confirmItem = nil } }),
                titleVisibility: .visible
            ) {
                Button("Add Item") { if let item = confirmItem { addItem(item) } }
                Button("Cancel", role: .cancel) { confirmItem = nil }
            }
        }
    }

    // MARK: - Active filter chips

    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let type = viewModel.selectedType {
                    TomeActiveFilterChip(label: type.capitalized) { viewModel.selectedType = nil }
                }
                if let rarity = viewModel.selectedRarity {
                    TomeActiveFilterChip(label: rarity.capitalized) { viewModel.selectedRarity = nil }
                }
                if let magic = viewModel.selectedMagic {
                    TomeActiveFilterChip(label: magic ? "Magic" : "Non-Magic") { viewModel.selectedMagic = nil }
                }
                Button("Clear all") { viewModel.clearFilters() }
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(1)
                    .foregroundStyle(Color.tomeCrimsonLight)
            }
        }
    }

    // MARK: - List

    private var itemList: some View {
        List {
            ForEach(viewModel.items) { item in
                itemRow(for: item)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func itemRow(for item: ItemModel) -> some View {
        let alreadyAdded = existingItemIDs.contains(item.id) || addedItemIDs.contains(item.id)

        Button {
            guard !alreadyAdded else { return }
            confirmItem = item
        } label: {
            HStack(spacing: 12) {
                Rectangle()
                    .fill(alreadyAdded ? Color.tomeSepia.opacity(0.3) : Color.tomeCrimson.opacity(0.6))
                    .frame(width: 2)
                    .cornerRadius(1)
                    .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.custom("Cinzel-Regular", size: 13))
                        .foregroundStyle(alreadyAdded ? Color.tomeSepia.opacity(0.5) : Color.tomeInk)
                        .lineLimit(1)
                    HStack(spacing: 5) {
                        if !item.type.isEmpty {
                            Text(item.type.capitalized)
                                .foregroundStyle(Color.tomeCrimsonLight)
                            Text("·").foregroundStyle(Color.tomeSepia.opacity(0.4))
                        }
                        Text(item.rarity.isEmpty ? "Common" : item.rarity.capitalized)
                            .foregroundStyle(Color.tomeParchmentText)
                        if item.isMagic {
                            Text("· ✦ Magic")
                                .foregroundStyle(Color.tomeGoldDim)
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

    private func addItem(_ item: ItemModel) {
        let newItem = Item(context: viewContext)
        newItem.id = item.id
        newItem.name = item.name
        newItem.type = item.type
        newItem.rarity = item.rarity
        newItem.desc = item.description
        newItem.isMagic = item.isMagic
        newItem.isHomebrew = false
        newItem.reqAttune = item.reqAttune != nil && !item.reqAttune!.isEmpty
        newItem.weight = Int16(item.weight ?? 0)
        newItem.value = Int16(item.value ?? 0)
        newItem.bonusWeapon = item.bonusWeapon
        newItem.bonusAc = item.bonusAc
        newItem.bonusSpellAttack = item.bonusSpellAttack
        newItem.bonusSpellSaveDc = item.bonusSpellSaveDc
        newItem.wondrous = item.wondrous ?? false
        if let character { newItem.addToCharacter(character) }
        try? viewContext.save()
        addedItemIDs.insert(item.id)
        confirmItem = nil
    }
}

// MARK: - Filter sheet

private struct ItemFilterSheet: View {
    @ObservedObject var viewModel: ItemLookupViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                HStack {
                    Text("Filter Items")
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
                        FilterPickerSection(title: "Type", icon: "tag") {
                            Picker("", selection: $viewModel.selectedType) {
                                Text("Any").tag(String?.none)
                                ForEach(viewModel.typeOptions, id: \.self) { t in
                                    Text(t.capitalized).tag(String?.some(t))
                                }
                            }
                        }
                        FilterPickerSection(title: "Rarity", icon: "star") {
                            Picker("", selection: $viewModel.selectedRarity) {
                                Text("Any").tag(String?.none)
                                ForEach(viewModel.rarityOptions, id: \.self) { r in
                                    Text(r.capitalized).tag(String?.some(r))
                                }
                            }
                        }
                        FilterPickerSection(title: "Magic", icon: "sparkles") {
                            Picker("", selection: $viewModel.selectedMagic) {
                                Text("Any").tag(Bool?.none)
                                Text("Magic Only").tag(Bool?.some(true))
                                Text("Non-Magic").tag(Bool?.some(false))
                            }
                        }

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

#Preview { AddItemView(character: nil) }
