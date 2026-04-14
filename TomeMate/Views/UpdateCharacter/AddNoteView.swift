//
//  AddNoteView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-29.
//

import SwiftUI

struct AddNoteView: View {
    let character: Character?
    @State private var title: String = ""
    @State private var content: String = ""
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            VStack(spacing: 0) {
                // Title field
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 5) {
                        Image(systemName: "pencil")
                            .font(.system(size: 10, weight: .light))
                            .foregroundStyle(Color.tomeSepia)
                        Text("Title".uppercased())
                            .font(.custom("Cinzel-Regular", size: 9))
                            .tracking(2)
                            .foregroundStyle(Color.tomeSepia)
                    }
                    TextField("Note title...", text: $title)
                        .font(.custom("Cinzel-Regular", size: 18))
                        .foregroundStyle(Color.tomeInk)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color.tomeParchment.opacity(0.88))
                        .cornerRadius(2)
                        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 14)

                Rectangle()
                    .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.3), .clear],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(height: 0.8)
                    .padding(.horizontal, 16)

                // Content editor with ruled lines
                ZStack(alignment: .topLeading) {
                    Color.tomeParchment.opacity(0.88)

                    RuledLinesView()

                    if content.isEmpty {
                        Text("Write here...")
                            .font(.custom("IMFellEnglish-Regular", size: 15))
                            .italic()
                            .foregroundStyle(Color.tomeParchmentText.opacity(0.45))
                            .padding(.top, 14)
                            .padding(.horizontal, 18)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $content)
                        .font(.custom("IMFellEnglish-Regular", size: 15))
                        .foregroundStyle(Color.tomeInk)
                        .padding(.horizontal, 12)
                        .padding(.top, 8)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    Rectangle()
                        .strokeBorder(Color.tomeSepia.opacity(0.2), lineWidth: 0.8)
                )
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 100)
            }

            // Save button
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.tomeBg.opacity(0), Color.tomeBg],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 30)

                SealButton("Save Note", isLoading: false) {
                    holder.createNote(title: title, desc: content, character: character!, context)
                    dismiss()
                }
                .disabled(!isValid)
                .opacity(isValid ? 1 : 0.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .background(Color.tomeBg)
            }
        }
        .navigationTitle("New Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    //AddNoteView()
}
