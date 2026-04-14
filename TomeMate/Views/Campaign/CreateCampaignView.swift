//
//  CreateCampaignView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct CreateCampaignView: View {
    @State private var title: String = ""
    let character: Character?
    @Binding var path: NavigationPath
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 28) {
                    WaxSealView()
                        .frame(width: 64, height: 64)
                        .opacity(0.9)

                    VStack(spacing: 8) {
                        Text("New Campaign")
                            .font(.custom("Cinzel-Regular", size: 22))
                            .foregroundStyle(Color.tomeParchment)

                        Text("Name the tale of your epic adventure")
                            .font(.custom("IMFellEnglish-Regular", size: 13))
                            .italic()
                            .foregroundStyle(Color.tomeMuted)
                            .multilineTextAlignment(.center)
                    }

                    DecorativeRuleView()
                        .padding(.horizontal, 60)

                    // Parchment-style text field
                    VStack(spacing: 0) {
                        TextField("", text: $title)
                            .font(.custom("Cinzel-Regular", size: 16))
                            .foregroundStyle(Color.tomeInk)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.tomeParchment.opacity(0.85))
                            .autocapitalization(.words)
                            .disableAutocorrection(false)
                        Rectangle()
                            .fill(Color.tomeSepia.opacity(0.5))
                            .frame(height: 1)
                    }
                    .cornerRadius(3)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                    .padding(.horizontal, 32)
                }

                Spacer()

                // Create button
                SealButton("Begin the Chronicle", isLoading: false) {
                    let campaign = holder.createCampaign(title: title, character: character!, context)
                    path.append(campaign)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
            }
        }
        .navigationTitle("Campaign")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

