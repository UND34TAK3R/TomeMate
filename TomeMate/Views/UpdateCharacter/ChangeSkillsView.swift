import SwiftUI

struct ChangeSkillsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder
    let character: Character?

    @State var skills: [SkillProficiencies] = []

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Skill Proficiencies")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView()
                            .padding(.horizontal, 60)
                        Text("Tap a skill to toggle proficiency")
                            .font(.custom("IMFellEnglish-Regular", size: 12))
                            .italic()
                            .foregroundStyle(Color.tomeMuted)
                    }
                    .padding(.vertical, 20)

                    VStack(spacing: 0) {
                        ForEach(Array(skills.enumerated()), id: \.element.objectID) { index, skill in
                            TomeSkillCard(skill: skill) {
                                skill.isProficient.toggle()
                            }
                            if index < skills.count - 1 {
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
                SealButton("Save Skills", isLoading: false) {
                    holder.updateSkill(character: character!, skills: skills, context)
                    dismiss()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .background(Color.tomeBg)
            }
        }
        .navigationTitle("Skills")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            skills = (character?.skillProf as? Set<SkillProficiencies>)?
                .sorted { ($0.name ?? "") < ($1.name ?? "") } ?? []
        }
    }
}

private struct TomeSkillCard: View {
    @ObservedObject var skill: SkillProficiencies
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Proficiency indicator
                ZStack {
                    Circle()
                        .strokeBorder(skill.isProficient ? Color.tomeGold : Color.tomeSepia.opacity(0.4), lineWidth: 1)
                        .frame(width: 20, height: 20)
                    if skill.isProficient {
                        Circle()
                            .fill(Color.tomeGold)
                            .frame(width: 12, height: 12)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: skill.isProficient)

                VStack(alignment: .leading, spacing: 2) {
                    Text(skill.name ?? "")
                        .font(.custom("IMFellEnglish-Regular", size: 14))
                        .foregroundStyle(skill.isProficient ? Color.tomeParchment : Color.tomeMuted)
                    Text((skill.ability ?? "").uppercased())
                        .font(.custom("Cinzel-Regular", size: 8))
                        .tracking(1.5)
                        .foregroundStyle(skill.isProficient ? Color.tomeGoldDim : Color.tomeSepia.opacity(0.5))
                }

                Spacer()

                if skill.isProficient {
                    Text("Proficient")
                        .font(.custom("Cinzel-Regular", size: 9))
                        .tracking(1)
                        .foregroundStyle(Color.tomeGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.tomeGold.opacity(0.1))
                        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeGold.opacity(0.3), lineWidth: 0.7))
                        .cornerRadius(2)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(TomeButtonStyle())
    }
}

#Preview {
    //ChangeSkillsView()
}
