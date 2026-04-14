//
//  AddQuestLogView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct AddQuestLogView: View {
    let quest: Quest
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss

    @State private var logEntry: String = ""

    var isValid: Bool {
        !logEntry.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // Quest title header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Quest")
                            .font(.custom("Cinzel-Regular", size: 9))
                            .tracking(2)
                            .foregroundStyle(Color.tomeMuted)
                        Text(quest.title ?? "Unknown Quest")
                            .font(.custom("Cinzel-Regular", size: 18))
                            .foregroundStyle(Color.tomeParchment)
                    }

                    Rectangle()
                        .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.4), .clear],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(height: 0.8)

                    // Log entry field
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "feather")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(Color.tomeSepia)
                            Text("Log Entry".uppercased())
                                .font(.custom("Cinzel-Regular", size: 9))
                                .tracking(2)
                                .foregroundStyle(Color.tomeSepia)
                        }

                        ZStack(alignment: .topLeading) {
                            // Ruled lines background
                            RuledLinesView()
                                .frame(minHeight: 200)

                            if logEntry.isEmpty {
                                Text("What happened on this adventure?")
                                    .font(.custom("IMFellEnglish-Regular", size: 14))
                                    .italic()
                                    .foregroundStyle(Color.tomeParchmentText.opacity(0.5))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                            }

                            TextEditor(text: $logEntry)
                                .font(.custom("IMFellEnglish-Regular", size: 14))
                                .foregroundStyle(Color.tomeInk)
                                .frame(minHeight: 200)
                                .padding(.horizontal, 8)
                                .padding(.top, 4)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                        }
                        .background(Color.tomeParchment.opacity(0.88))
                        .cornerRadius(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(Color.tomeSepia.opacity(0.35), lineWidth: 0.8)
                        )
                    }

                    SealButton("Record Entry", isLoading: false) {
                        holder.updateQuest(log: logEntry, status: nil, quest: quest, context)
                        dismiss()
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1 : 0.5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("New Log Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
