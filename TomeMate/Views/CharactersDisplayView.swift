//
//  CharactersDisplayView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//
import SwiftUI
import CoreData

struct CharactersDisplayView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                if holder.characters.isEmpty {
                    emptyState
                } else {
                    characterList
                }
            }
        }
        .navigationTitle("Character Selection")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: CharacterFormView(path: $path)) {
                    Image(systemName: "plus")
                        .foregroundColor(.tomeGold)
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            D20IconView()
                .frame(width: 72, height: 72)
                .opacity(0.5)

            VStack(spacing: 8) {
                Text("No Adventurers Yet")
                    .font(.custom("Cinzel-Regular", size: 18))
                    .foregroundStyle(Color.tomeParchment)
                Text("Begin your legend by creating your first character.")
                    .font(.custom("IMFellEnglish-Regular", size: 13))
                    .italic()
                    .foregroundStyle(Color.tomeMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            DecorativeRuleView()
                .padding(.horizontal, 60)

            NavigationLink(destination: CharacterFormView(path: $path)) {
                SealButton("Create Character", isLoading: false) {}
            }
            .padding(.horizontal, 40)
            Spacer()
        }
    }

    // MARK: - Character List
    private var characterList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(holder.characters) { character in
                    NavigationLink(value: character) {
                        CharacterRow(character: character)
                    }
                    .buttonStyle(TomeButtonStyle())
                }

                // Add button at bottom
                NavigationLink(destination: CharacterFormView(path: $path)) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .light))
                            .foregroundStyle(Color.tomeGold)
                        Text("New Character")
                            .font(.custom("Cinzel-Regular", size: 12))
                            .tracking(1.5)
                            .foregroundStyle(Color.tomeGold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.tomeParchment.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .strokeBorder(Color.tomeGold.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(3)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.map { holder.characters[$0] }.forEach {
            holder.deleteCharacter($0, context)
        }
    }
}

// MARK: - Character Row
struct CharacterRow: View {
    @ObservedObject var character: Character

    var body: some View {
        let name = character.name ?? "Unknown"
        let level = character.level
        let alignment = character.alignment ?? "Neutral"
        let classes = (character.classes as? Set<Classes>)?.sorted { $0.level < $1.level } ?? []

        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.tomeLeather)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(Color.tomeSepia.opacity(0.4), lineWidth: 0.8)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)

            HStack(spacing: 14) {
                Rectangle()
                    .fill(Color.tomeCrimson.opacity(0.7))
                    .frame(width: 3)
                    .cornerRadius(2)
                    .padding(.vertical, 14)

                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.custom("Cinzel-Regular", size: 15))
                        .foregroundStyle(Color.tomeParchment)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        Text(alignment)
                            .font(.custom("IMFellEnglish-Regular", size: 11))
                            .italic()
                            .foregroundStyle(Color.tomeMuted)

                        Text("·")
                            .foregroundStyle(Color.tomeSepia)

                        Text(classesString(classes: classes))
                            .font(.custom("IMFellEnglish-Regular", size: 11))
                            .italic()
                            .foregroundStyle(Color.tomeMuted)
                            .lineLimit(1)
                    }
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(level)")
                        .font(.custom("Cinzel-Bold", size: 18))
                        .foregroundStyle(Color.tomeGold)
                    Text("LVL")
                        .font(.custom("Cinzel-Regular", size: 8))
                        .tracking(1.5)
                        .foregroundStyle(Color.tomeGoldDim)
                }
                .padding(.trailing, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 74)
    }

    private func classesString(classes: [Classes]) -> String {
        let names = classes.compactMap { $0.name }
        if names.isEmpty { return "N/A" }
        let displayed = names.prefix(2).joined(separator: " / ")
        return names.count > 2 ? "\(displayed)..." : displayed
    }
}

#Preview {
    // CharactersDisplayView()
}
