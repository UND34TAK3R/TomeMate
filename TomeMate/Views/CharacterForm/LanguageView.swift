//
//  Page9.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//
import SwiftUI

struct LanguageView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @StateObject var viewModel = LanguageViewModel()
    @State var languages: [LanguageModel] = []
    @State var manualSelections: Set<String> = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    func isGranted(_ language: LanguageModel) -> Bool {
        let name = language.name.lowercased().trimmingCharacters(in: .whitespaces)
        let fromRace = formData.race.languages
            .map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
            .contains(name)
        let fromSubrace = formData.subrace?.languages
            .map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
            .contains(name) ?? false
        return fromRace || fromSubrace
    }

    func isProficient(_ language: LanguageModel) -> Bool {
        manualSelections.contains(language.name) || isGranted(language)
    }

    var body: some View {
        VStack(alignment: .center) {
            Text("Select your Languages")
                .font(.title)
                .bold()
                .padding(.vertical, 10)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(languages) { language in
                        LanguageCard(
                            language: language,
                            isProficient: isProficient(language)
                        ) {
                            if manualSelections.contains(language.name) {
                                manualSelections.remove(language.name)
                            } else {
                                manualSelections.insert(language.name)
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            formData.languages = languages.filter { isProficient($0) }
        }
        .onAppear {
            isDisabled = false
            viewModel.fetchLanguages()  // always fetch so viewModel.languages is populated
            if !formData.languages.isEmpty {
                languages = viewModel.languages
                manualSelections = Set(
                    formData.languages
                        .filter { !isGranted($0) }
                        .map { $0.name }
                )
            }
        }
        .onChange(of: viewModel.languages) { newLanguages in
            languages = newLanguages
        }
        .onChange(of: formData.race.languages) { _ in
            manualSelections.removeAll()
            formData.languages.removeAll()
            languages = viewModel.languages
            
        }
        .onChange(of: formData.subrace?.languages) { _ in
            manualSelections.removeAll()
            formData.languages.removeAll()
            languages = viewModel.languages
        }
    }
}

struct LanguageCard: View {
    let language: LanguageModel
    let isProficient: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(language.name)
            Spacer()
            ZStack {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: 20, height: 20)
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.blue)
                    .scaleEffect(isProficient ? 1 : 0)
            }
        }
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}

