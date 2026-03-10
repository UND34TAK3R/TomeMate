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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                if holder.characters.isEmpty {
                    VStack(spacing: 20) {
                        ContentUnavailableView("No characters are created", systemImage: "person.fill")
                        addCharacterButton
                    }
                    .padding(.top, 60)
                    Spacer()
                } else {
                    List {
                        ForEach(holder.characters) { character in
                            NavigationLink {
                                CharacterOverviewView(character: character)
                            } label: {
                                CharacterRow(character: character)
                            }
                            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)

                    addCharacterButton
                        .padding(.vertical, 10)
                }
            }
            .navigationTitle("Character Selection")
            .padding(.horizontal)
        }
    }
    
    // MARK: Add Character Button
    private var addCharacterButton: some View {
        NavigationLink(destination: CharacterFormView()) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 2)
                .overlay {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .font(.title)
                        Text("New Character")
                            .bold()
                        Spacer()
                    }
                    .padding()
                }
                .frame(height: 60)
                .border(Color.black, width: 2)
        }
        .padding(.horizontal)
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.map { holder.characters[$0] }.forEach {
            holder.deleteCharacter($0, context)
        }
    }
}

// MARK: Character Row
struct CharacterRow: View {
    @ObservedObject var character: Character
    
    var body: some View {
        let name = character.name ?? "Name"
        let level = character.level
        let alignment = character.alignment ?? "Neutral"
        let classes = (character.classes as? Set<Classes>)?.sorted {
            ($0.level) < ($1.level)
        } ?? []
    
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .shadow(radius: 1)
            .overlay {
                VStack(spacing: 4) {
                    HStack {
                        Text(name)
                            .font(.headline)
                        Spacer()
                        Text("Lvl \(level)")
                    }
                    HStack {
                        Text(alignment)
                        Spacer()
                        Text(classesString(classes: classes))
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .border(Color.black, width: 1)
    }
    
    private func classesString(classes: [Classes]) -> String {
        let names = classes.compactMap { $0.name }
        print(names)
        if names.isEmpty { return "N/A" }
        let displayed = names.prefix(2).joined(separator: " / ")
        return names.count > 2 ? "\(displayed)..." : displayed
    }
}

// MARK: Preview
#Preview {
    CharactersDisplayView()
}
