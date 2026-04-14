//
//  QuestLog.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct QuestLogView: View {
    let campaign: Campaign
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    var campaignQuests: [Quest] {
        holder.quests.filter { $0.campaign == campaign }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    if campaignQuests.isEmpty {
                        TomeEmptyStateView(message: "No quests yet. Begin the adventure.")
                    } else {
                        ForEach(campaignQuests, id: \.self) { q in
                            NavigationLink {
                                QuestDetailView(quest: q)
                            } label: {
                                QuestCard(quest: q)
                            }
                            .buttonStyle(TomeButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
            .navigationTitle(campaign.name ?? "Quest Log")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddQuestView(campaign: campaign)) {
                        Image(systemName: "plus")
                            .foregroundColor(.tomeGold)
                    }
                }
            }

            // World Map FAB
            NavigationLink(destination: WorldMapView(campaign: campaign)) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.tomeCrimson, Color("#A02020")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.tomeCrimson.opacity(0.5), radius: 12, x: 0, y: 4)
                    Image(systemName: "map")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.tomeParchment)
                }
                .frame(width: 58, height: 58)
            }
            .padding(24)
        }
    }
}

// MARK: - Quest Card
struct QuestCard: View {
    let quest: Quest

    var statusColor: Color {
        switch quest.status {
        case "Active": return Color.tomeGoldLight
        case "Completed": return Color("#4A7A3A")
        case "Failed": return Color.tomeCrimsonLight
        default: return Color.tomeMuted
        }
    }

    var statusIcon: String {
        switch quest.status {
        case "Active": return "clock.fill"
        case "Completed": return "checkmark.circle.fill"
        case "Failed": return "xmark.circle.fill"
        default: return "circle"
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.tomeLeather)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(Color.tomeSepia.opacity(0.35), lineWidth: 0.8)
                )
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)

            HStack(spacing: 0) {
                // Status bar
                Rectangle()
                    .fill(statusColor)
                    .frame(width: 3)
                    .padding(.vertical, 12)
                    .cornerRadius(2)

                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(quest.title ?? "Unknown Quest")
                            .font(.custom("Cinzel-Regular", size: 14))
                            .foregroundStyle(Color.tomeParchment)
                            .lineLimit(1)

                        if let desc = quest.desc, !desc.isEmpty {
                            Text(desc)
                                .font(.custom("IMFellEnglish-Regular", size: 11))
                                .italic()
                                .foregroundStyle(Color.tomeMuted)
                                .lineLimit(2)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: statusIcon)
                                .font(.system(size: 9, weight: .light))
                            Text(quest.status ?? "")
                                .font(.custom("IMFellEnglish-Regular", size: 10))
                                .italic()
                        }
                        .foregroundColor(statusColor)
                        .padding(.top, 2)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundStyle(Color.tomeSepia)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 80)
    }
}
