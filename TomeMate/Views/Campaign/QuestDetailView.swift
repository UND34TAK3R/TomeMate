import SwiftUI

struct QuestDetailView: View {
    @ObservedObject var quest: Quest
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    @State private var showStatusPicker = false

    let statuses = ["Active", "Completed", "Failed"]

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

    var logs: [String] { quest.logs ?? [] }

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Quest Header Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: statusIcon)
                                    .font(.system(size: 10, weight: .light))
                                Text(quest.status ?? "Unknown")
                                    .font(.custom("IMFellEnglish-Regular", size: 11))
                                    .italic()
                            }
                            .foregroundColor(statusColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(statusColor.opacity(0.12))
                            .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(statusColor.opacity(0.3), lineWidth: 0.7))
                            .cornerRadius(2)

                            Spacer()

                            Button {
                                withAnimation { showStatusPicker.toggle() }
                            } label: {
                                Text("Change Status")
                                    .font(.custom("Cinzel-Regular", size: 9))
                                    .tracking(1)
                                    .foregroundStyle(Color.tomeMuted)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.tomeSpine)
                                    .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeSepia.opacity(0.4), lineWidth: 0.7))
                                    .cornerRadius(2)
                            }
                            .buttonStyle(TomeButtonStyle())
                        }

                        if let desc = quest.desc, !desc.isEmpty {
                            Text(desc)
                                .font(.custom("IMFellEnglish-Regular", size: 14))
                                .italic()
                                .foregroundStyle(Color.tomeParchment.opacity(0.85))
                        }

                        Rectangle()
                            .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.35), .clear],
                                                 startPoint: .leading, endPoint: .trailing))
                            .frame(height: 0.8)

                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12, weight: .light))
                                .foregroundStyle(Color.tomeSepia)
                            Text(quest.location ?? "N/A")
                                .font(.custom("IMFellEnglish-Regular", size: 12))
                                .italic()
                                .foregroundStyle(Color.tomeMuted)
                        }

                        // Pin actions
                        if quest.pin == nil {
                            NavigationLink(destination: PinPlacementMapView(quest: quest)) {
                                HStack(spacing: 6) {
                                    Image(systemName: "mappin.badge.plus")
                                        .font(.system(size: 10, weight: .light))
                                    Text("Pin on Map")
                                        .font(.custom("IMFellEnglish-Regular", size: 11))
                                        .italic()
                                }
                                .foregroundColor(Color.tomeGoldLight)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.tomeGoldLight.opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeGoldLight.opacity(0.3), lineWidth: 0.7))
                                .cornerRadius(2)
                            }
                        } else {
                            HStack(spacing: 8) {
                                NavigationLink(destination: WorldMapView(campaign: quest.campaign!)) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "map.fill")
                                            .font(.system(size: 10, weight: .light))
                                        Text("View on Map")
                                            .font(.custom("IMFellEnglish-Regular", size: 11))
                                            .italic()
                                    }
                                    .foregroundColor(Color.tomeGold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.tomeGold.opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeGold.opacity(0.3), lineWidth: 0.7))
                                    .cornerRadius(2)
                                }

                                Button {
                                    holder.deletePin(quest.pin!, context)
                                } label: {
                                    HStack(spacing: 5) {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 10, weight: .light))
                                        Text("Delete Pin")
                                            .font(.custom("IMFellEnglish-Regular", size: 11))
                                            .italic()
                                    }
                                    .foregroundColor(Color.tomeCrimsonLight)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.tomeCrimson.opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeCrimson.opacity(0.3), lineWidth: 0.7))
                                    .cornerRadius(2)
                                }
                                .buttonStyle(TomeButtonStyle())
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.tomeLeather)
                    .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.35), lineWidth: 0.8))
                    .cornerRadius(3)

                    // MARK: - Status Picker
                    if showStatusPicker {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Update Status")
                                .font(.custom("Cinzel-Regular", size: 9))
                                .tracking(2)
                                .foregroundStyle(Color.tomeMuted)

                            HStack(spacing: 8) {
                                ForEach(statuses, id: \.self) { status in
                                    let color: Color = status == "Active" ? Color.tomeGoldLight : status == "Completed" ? Color("#4A7A3A") : Color.tomeCrimsonLight
                                    Button {
                                        holder.updateQuest(log: nil, status: status, quest: quest, context)
                                        withAnimation { showStatusPicker = false }
                                    } label: {
                                        Text(status)
                                            .font(.custom("IMFellEnglish-Regular", size: 12))
                                            .italic()
                                            .foregroundColor(quest.status == status ? Color.tomeParchment : color)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(quest.status == status ? color : color.opacity(0.1))
                                            .cornerRadius(2)
                                            .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(color.opacity(0.4), lineWidth: 0.7))
                                    }
                                    .buttonStyle(TomeButtonStyle())
                                }
                            }
                        }
                        .padding(14)
                        .background(Color.tomeLeather)
                        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
                        .cornerRadius(3)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // MARK: - Quest Log
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            HStack(spacing: 6) {
                                Rectangle()
                                    .fill(Color.tomeCrimson.opacity(0.7))
                                    .frame(width: 2, height: 12)
                                    .cornerRadius(1)
                                Text("Quest Log")
                                    .font(.custom("Cinzel-Regular", size: 10))
                                    .tracking(2)
                                    .foregroundStyle(Color.tomeMuted)
                            }
                            Spacer()
                            NavigationLink(destination: AddQuestLogView(quest: quest)) {
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .light))
                                    .foregroundStyle(Color.tomeGold)
                            }
                        }

                        if logs.isEmpty {
                            Text("No log entries yet. Record your deeds.")
                                .font(.custom("IMFellEnglish-Regular", size: 12))
                                .italic()
                                .foregroundStyle(Color.tomeMuted)
                                .padding(.top, 4)
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(logs.enumerated()), id: \.offset) { index, entry in
                                    HStack(alignment: .top, spacing: 14) {
                                        VStack(spacing: 0) {
                                            Circle()
                                                .fill(Color.tomeGold.opacity(0.5))
                                                .frame(width: 7, height: 7)
                                                .padding(.top, 5)
                                            if index < logs.count - 1 {
                                                Rectangle()
                                                    .fill(Color.tomeSepia.opacity(0.3))
                                                    .frame(width: 1)
                                                    .frame(minHeight: 30)
                                                    .padding(.top, 2)
                                            }
                                        }
                                        .frame(width: 8)

                                        Text(entry)
                                            .font(.custom("IMFellEnglish-Regular", size: 13))
                                            .italic()
                                            .foregroundStyle(Color.tomeParchment.opacity(0.9))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.bottom, 20)
                                    }
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(16)
                    .background(Color.tomeLeather)
                    .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
                    .cornerRadius(3)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(quest.title ?? "Quest")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .animation(.easeInOut(duration: 0.2), value: showStatusPicker)
    }
}
