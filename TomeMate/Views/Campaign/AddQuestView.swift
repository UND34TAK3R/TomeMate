//
//  AddQuestView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct AddQuestView: View {
    let campaign: Campaign
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var location: String = ""

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    TomeQuestField(label: "Quest Title", icon: "scroll", placeholder: "Enter quest title") {
                        TextField("Enter quest title", text: $title)
                            .font(.custom("IMFellEnglish-Regular", size: 15))
                            .foregroundStyle(Color.tomeInk)
                            .autocapitalization(.words)
                    }

                    TomeQuestField(label: "Description", icon: "text.alignleft", placeholder: "") {
                        ZStack(alignment: .topLeading) {
                            if desc.isEmpty {
                                Text("What is this quest about?")
                                    .font(.custom("IMFellEnglish-Regular", size: 14))
                                    .italic()
                                    .foregroundStyle(Color.tomeParchmentText.opacity(0.5))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 4)
                            }
                            TextEditor(text: $desc)
                                .font(.custom("IMFellEnglish-Regular", size: 14))
                                .foregroundStyle(Color.tomeInk)
                                .frame(minHeight: 110)
                                .scrollContentBackground(.hidden)
                        }
                    }

                    TomeQuestField(label: "Location", icon: "mappin", placeholder: "Optional location") {
                        TextField("Optional location", text: $location)
                            .font(.custom("IMFellEnglish-Regular", size: 15))
                            .foregroundStyle(Color.tomeInk)
                            .autocapitalization(.words)
                    }

                    Spacer(minLength: 20)

                    SealButton("Add Quest", isLoading: false) {
                        let loc = location.trimmingCharacters(in: .whitespaces)
                        holder.createQuest(
                            title: title,
                            desc: desc,
                            campaign: campaign,
                            location: loc.isEmpty ? nil : loc,
                            context
                        )
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
        .navigationTitle("New Quest")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

private struct TomeQuestField<Content: View>: View {
    let label: String
    let icon: String
    let placeholder: String
    let content: () -> Content

    init(label: String, icon: String, placeholder: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.icon = icon
        self.placeholder = placeholder
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .light))
                    .foregroundStyle(Color.tomeSepia)
                Text(label.uppercased())
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(2)
                    .foregroundStyle(Color.tomeSepia)
            }
            content()
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.tomeParchment.opacity(0.82))
                .cornerRadius(2)
                .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        }
    }
}
