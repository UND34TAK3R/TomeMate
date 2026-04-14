//
//  ChangeStatsView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-28.
//

import SwiftUI

struct ChangeStatsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder
    let character: Character?

    @State var stats: Stats?
    @State var strvalue: Double = 10
    @State var dexvalue: Double = 10
    @State var convalue: Double = 10
    @State var intvalue: Double = 10
    @State var wisvalue: Double = 10
    @State var chavalue: Double = 10

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Ability Scores")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView()
                            .padding(.horizontal, 60)
                    }
                    .padding(.vertical, 20)

                    VStack(spacing: 0) {
                        TomeStatSliderRow(label: "Strength",     abbr: "STR", value: $strvalue)
                        tomeHairline
                        TomeStatSliderRow(label: "Dexterity",    abbr: "DEX", value: $dexvalue)
                        tomeHairline
                        TomeStatSliderRow(label: "Constitution", abbr: "CON", value: $convalue)
                        tomeHairline
                        TomeStatSliderRow(label: "Intelligence", abbr: "INT", value: $intvalue)
                        tomeHairline
                        TomeStatSliderRow(label: "Wisdom",       abbr: "WIS", value: $wisvalue)
                        tomeHairline
                        TomeStatSliderRow(label: "Charisma",     abbr: "CHA", value: $chavalue)
                    }
                    .background(Color.tomeLeather)
                    .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
                    .cornerRadius(3)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }

            // Save button
            VStack(spacing: 0) {
                LinearGradient(colors: [Color.tomeBg.opacity(0), Color.tomeBg],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
                SealButton("Save Stats", isLoading: false) {
                    holder.updateStat(str: strvalue, dex: dexvalue, con: convalue,
                                      int: intvalue, wis: wisvalue, cha: chavalue,
                                      stat: stats!, context)
                    dismiss()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .background(Color.tomeBg)
            }
        }
        .navigationTitle("Ability Scores")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            stats     = character?.stats
            strvalue  = Double(stats?.strength    ?? 0)
            dexvalue  = Double(stats?.dexterity   ?? 0)
            convalue  = Double(stats?.constitution ?? 0)
            intvalue  = Double(stats?.intelligence ?? 0)
            wisvalue  = Double(stats?.wisdom      ?? 0)
            chavalue  = Double(stats?.charisma    ?? 0)
        }
    }

    private var tomeHairline: some View {
        Rectangle()
            .fill(Color.tomeSepia.opacity(0.2))
            .frame(height: 0.8)
            .padding(.leading, 16)
    }
}

// MARK: - Stat Slider Row
private struct TomeStatSliderRow: View {
    let label: String
    let abbr: String
    @Binding var value: Double

    private var modifier: String {
        let mod = Int(floor((value - 10) / 2))
        return mod >= 0 ? "+\(mod)" : "\(mod)"
    }

    var body: some View {
        HStack(spacing: 16) {
            // Abbr label
            Text(abbr)
                .font(.custom("Cinzel-Regular", size: 9))
                .tracking(2)
                .foregroundStyle(Color.tomeMuted)
                .frame(width: 28)

            // Full name
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .foregroundStyle(Color.tomeParchment)

            Spacer()

            // Minus
            Button {
                if value > 1 { value -= 1 }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.tomeCrimsonLight)
                    .frame(width: 28, height: 28)
                    .background(Color.tomeSpine)
                    .cornerRadius(2)
            }
            .buttonStyle(TomeButtonStyle())

            // Value + modifier
            VStack(spacing: 1) {
                Text("\(Int(value))")
                    .font(.custom("Cinzel-Bold", size: 20))
                    .foregroundStyle(Color.tomeParchment)
                Text(modifier)
                    .font(.custom("Cinzel-Regular", size: 10))
                    .foregroundStyle(Color.tomeGold)
            }
            .frame(width: 44)

            // Plus
            Button {
                if value < 20 { value += 1 }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.tomeGold)
                    .frame(width: 28, height: 28)
                    .background(Color.tomeSpine)
                    .cornerRadius(2)
            }
            .buttonStyle(TomeButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}



#Preview {
    // ChangeStatsView()
}

