//
//  ChangeLanguagesView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//

import SwiftUI

struct ChangeLanguagesView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder
    let character: Character
    @StateObject var viewModel = LanguageViewModel()
    @State var languages: [LanguageModel] = []
    @State var manualSelections: Set<String> = []
    @State private var grantedLanguages: Set<String> = []

    func isGranted(_ language: LanguageModel) -> Bool {
        grantedLanguages.contains(language.name)
    }

    func isProficient(_ language: LanguageModel) -> Bool {
        manualSelections.contains(language.name) || isGranted(language)
    }

    var selectedCount: Int {
        languages.filter { isProficient($0) }.count
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Languages")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView()
                            .padding(.horizontal, 60)
                        Text("\(selectedCount) selected")
                            .font(.custom("IMFellEnglish-Regular", size: 12))
                            .italic()
                            .foregroundStyle(Color.tomeGold)
                    }
                    .padding(.vertical, 20)

                    VStack(spacing: 0) {
                        ForEach(Array(languages.enumerated()), id: \.element.id) { index, language in
                            TomeLanguageCard(
                                language: language,
                                isProficient: isProficient(language),
                                isLocked: isGranted(language)
                            ) {
                                guard !isGranted(language) else { return }
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    if manualSelections.contains(language.name) {
                                        manualSelections.remove(language.name)
                                    } else {
                                        manualSelections.insert(language.name)
                                    }
                                }
                            }
                            if index < languages.count - 1 {
                                Rectangle()
                                    .fill(Color.tomeSepia.opacity(0.2))
                                    .frame(height: 0.8)
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .background(Color.tomeLeather)
                    .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
                    .cornerRadius(3)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }

            VStack(spacing: 0) {
                LinearGradient(colors: [Color.tomeBg.opacity(0), Color.tomeBg],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
                SealButton("Save Languages", isLoading: false) {
                    let selected = languages.filter { isProficient($0) }
                    holder.updateLanguage(character: character, languages: selected, context)
                    dismiss()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .background(Color.tomeBg)
            }
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            viewModel.fetchLanguages()
            manualSelections = Set(character.languages ?? [])
            grantedLanguages = []
        }
        .onChange(of: viewModel.languages) { newLanguages in
            languages = newLanguages
        }
    }
}

private struct TomeLanguageCard: View {
    let language: LanguageModel
    let isProficient: Bool
    let isLocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            isLocked ? Color.tomeSepia.opacity(0.3) : (isProficient ? Color.tomeGold : Color.tomeSepia.opacity(0.4)),
                            lineWidth: 1
                        )
                        .frame(width: 20, height: 20)
                    if isProficient {
                        Circle()
                            .fill(isLocked ? Color.tomeSepia.opacity(0.5) : Color.tomeGold)
                            .frame(width: 12, height: 12)
                    }
                }

                Text(language.name)
                    .font(.custom("IMFellEnglish-Regular", size: 14))
                    .foregroundStyle(isProficient ? Color.tomeParchment : Color.tomeMuted)

                Spacer()

                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .light))
                        .foregroundStyle(Color.tomeSepia.opacity(0.5))
                } else if isProficient {
                    Text("Known")
                        .font(.custom("Cinzel-Regular", size: 9))
                        .tracking(1)
                        .foregroundStyle(Color.tomeGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.tomeGold.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeGold.opacity(0.3), lineWidth: 0.7))
                        .cornerRadius(2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(TomeButtonStyle())
        .disabled(isLocked)
    }
}
