import SwiftUI
 
struct CharacterOverviewView: View {
 
    @State var character: Character?
    @Binding var path: NavigationPath
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
 
    // MARK: - Computed helpers (pulled out to avoid type-checker overload)
 
    private var classNames: String {
        (character?.classes as? Set<Classes>)
            .map { $0.compactMap { $0.name }.sorted().joined(separator: " / ") } ?? "—"
    }
 
    private var subclassNames: String {
        (character?.classes as? Set<Classes>)
            .map { $0.compactMap { $0.subclass }.sorted().joined(separator: " / ") } ?? "—"
    }
 
    private var proficientSkills: [SkillProficiencies] {
        (character?.skillProf as? Set<SkillProficiencies>)?
            .filter { $0.isProficient }
            .sorted { ($0.name ?? "") < ($1.name ?? "") } ?? []
    }
 
    // MARK: - Body
 
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()
            CornerOrnamentView()
 
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    tomeRule
                    combatStatsSection
                    tomeRule
                    detailsSection
                    tomeRule
                    statsSection
                    tomeRule
                    skillsSection
                    tomeRule
                    languagesSection
                    tomeRule
                    quickAccessSection
                        .padding(.bottom, 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { path = NavigationPath() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.tomeGold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink { UpdateCharacterView(character: character!) } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.tomeGold)
                    }
                }
            }
            .navigationTitle(character?.name ?? "Overview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
 
            levelUpFAB
        }
    }
 
    // MARK: - Header
 
    private var headerSection: some View {
        HStack(spacing: 16) {
            avatarView
            characterNameStack
            Spacer()
        }
        .padding(.top, 8)
    }
 
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.tomeLeather)
                .overlay(Circle().strokeBorder(Color.tomeGold.opacity(0.4), lineWidth: 1.5))
            if let image = character?.charImg {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .foregroundColor(.tomeSepia)
                    .font(.system(size: 24))
            }
        }
        .frame(width: 60, height: 60)
    }
 
    private var characterNameStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(character?.name ?? "Unknown")
                .font(.custom("Cinzel-Regular", size: 20))
                .foregroundStyle(Color.tomeParchment)
 
            HStack(spacing: 6) {
                Text("Level \(character?.level ?? 1)")
                    .font(.custom("Cinzel-Regular", size: 10))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeParchment)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.tomeCrimson.opacity(0.7))
                    .cornerRadius(2)
 
                Text("\(character?.race ?? "—")  ·  \(classNames)")
                    .font(.custom("IMFellEnglish-Regular", size: 12))
                    .italic()
                    .foregroundStyle(Color.tomeMuted)
            }
        }
    }
 
    // MARK: - Combat Stats
 
    private var combatStatsSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 0) {
                TomeCombatStat(icon: "heart.fill",   value: "\(character?.hp ?? 0)",              label: "Hit Points", accentColor: .tomeCrimson)
                Spacer()
                TomeCombatStat(icon: "shield.fill",  value: "\(character?.armorClass ?? 0)",      label: "Armor Class", accentColor: .tomeGold)
                Spacer()
                TomeCombatStat(icon: "bolt.fill",    value: "\(character?.initiative ?? 0)",      label: "Initiative", accentColor: .tomeGoldLight)
                Spacer()
                TomeCombatStat(icon: "eye.fill",     value: "\(character?.passivePerception ?? 0)", label: "Perception", accentColor: .tomeSepia)
                Spacer()
                TomeCombatStat(icon: "figure.walk",  value: "\(character?.speed ?? "30")",        label: "Speed", accentColor: .tomeMuted)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .background(Color.tomeLeather)
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.35), lineWidth: 0.8))
            .cornerRadius(3)
 
            resourcePills
        }
    }
 
    private var resourcePills: some View {
        HStack(spacing: 8) {
            if character?.useXp == true {
                TomeResourcePill(icon: "circle.fill", label: "\(character?.experiencePoints ?? 0) xp", color: .tomeGold)
            }
            TomeResourcePill(icon: "circle.fill", label: "\(character?.gold ?? 0) gp", color: Color("#C8962E"))
            TomeResourcePill(icon: "sparkles",    label: "\(character?.inspiration ?? 0) Insp.", color: Color.tomeParchmentDark)
            Spacer()
        }
    }
 
    // MARK: - Details
 
    private var detailsSection: some View {
        VStack(spacing: 0) {
            TomeDetailRow(label: "Subclass",   value: subclassNames)
            tomeHairline
            TomeDetailRow(label: "Subrace",    value: character?.subrace ?? "—")
            tomeHairline
            TomeDetailRow(label: "Background", value: character?.background ?? "—")
            tomeHairline
            TomeDetailRow(label: "Alignment",  value: character?.alignment ?? "—")
            tomeHairline
            TomeDetailRow(label: "Age",        value: "\(character?.age ?? 0) years old")
        }
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }
 
    // MARK: - Stats
 
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ability Scores")
                    .font(.custom("Cinzel-Regular", size: 10))
                    .tracking(2)
                    .foregroundStyle(Color.tomeMuted)
                Spacer()
                NavigationLink(destination: ChangeStatsView(character: character ?? nil)) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(Color.tomeGold)
                }
            }
 
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                TomeMiniStat(label: "STR", value: character?.stats?.strength    ?? 0)
                TomeMiniStat(label: "DEX", value: character?.stats?.dexterity   ?? 0)
                TomeMiniStat(label: "CON", value: character?.stats?.constitution ?? 0)
                TomeMiniStat(label: "INT", value: character?.stats?.intelligence ?? 0)
                TomeMiniStat(label: "WIS", value: character?.stats?.wisdom      ?? 0)
                TomeMiniStat(label: "CHA", value: character?.stats?.charisma    ?? 0)
            }
        }
    }
 
    // MARK: - Skills
 
    private var skillsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Skill Proficiencies")
                    .font(.custom("Cinzel-Regular", size: 10))
                    .tracking(2)
                    .foregroundStyle(Color.tomeMuted)
                Spacer()
                NavigationLink(destination: ChangeSkillsView(character: character ?? nil)) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(Color.tomeGold)
                }
            }
 
            if proficientSkills.isEmpty {
                Text("No proficiencies recorded.")
                    .font(.custom("IMFellEnglish-Regular", size: 12))
                    .italic()
                    .foregroundStyle(Color.tomeMuted)
            } else {
                skillsList
            }
        }
    }
 
    private var skillsList: some View {
        VStack(spacing: 0) {
            ForEach(Array(proficientSkills.enumerated()), id: \.element) { index, skill in
                skillRow(skill: skill, isLast: index == proficientSkills.count - 1)
            }
        }
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }
 
    private func skillRow(skill: SkillProficiencies, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Rectangle()
                    .fill(Color.tomeCrimson.opacity(0.6))
                    .frame(width: 2, height: 14)
                    .cornerRadius(1)
                Text(skill.name ?? "—")
                    .font(.custom("IMFellEnglish-Regular", size: 13))
                    .foregroundStyle(Color.tomeParchment)
                Spacer()
                Text("+\(character?.proficiencyBonus ?? 0)")
                    .font(.custom("Cinzel-Regular", size: 11))
                    .foregroundStyle(Color.tomeGold)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
 
            if !isLast {
                Rectangle()
                    .fill(Color.tomeSepia.opacity(0.2))
                    .frame(height: 0.8)
                    .padding(.leading, 28)
            }
        }
    }
 
    // MARK: - Languages
 
    private var languagesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Languages")
                    .font(.custom("Cinzel-Regular", size: 10))
                    .tracking(2)
                    .foregroundStyle(Color.tomeMuted)
                Spacer()
                NavigationLink(destination: ChangeLanguagesView(character: character!)) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(Color.tomeGold)
                }
            }
 
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(character?.languages ?? [], id: \.self) { lang in
                        Text(lang)
                            .font(.custom("IMFellEnglish-Regular", size: 11))
                            .italic()
                            .foregroundStyle(Color.tomeParchment)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.tomeLeather)
                            .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeSepia.opacity(0.4), lineWidth: 0.8))
                            .cornerRadius(2)
                    }
                }
            }
        }
    }
 
    // MARK: - Quick Access
 
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Access")
                .font(.custom("Cinzel-Regular", size: 10))
                .tracking(2)
                .foregroundStyle(Color.tomeMuted)
 
            TomeQuickAccessLink(destination: AnyView(SpellsView(character: character)), icon: "sparkles",  label: "Spells", accent: Color.tomeGoldLight)
            TomeQuickAccessLink(destination: AnyView(ItemsView(character: character)),  icon: "bag.fill",  label: "Items",  accent: Color("#C8962E"))
            TomeQuickAccessLink(destination: AnyView(NotesView(character: character)),  icon: "note.text", label: "Notes",  accent: Color.tomeParchmentDark)
            campaignLink
        }
    }
 
    private var campaignLink: some View {
        NavigationLink(
            destination: Group {
                if character?.campaign == nil {
                    CreateCampaignView(character: character!, path: $path)
                } else {
                    QuestLogView(campaign: character!.campaign!)
                }
            }
        ) {
            HStack(spacing: 10) {
                Image(systemName: "map")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color.tomeCrimsonLight)
                Text("Campaign")
                    .font(.custom("Cinzel-Regular", size: 12))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeParchment)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Color.tomeSepia)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.tomeLeather)
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeCrimson.opacity(0.3), lineWidth: 0.8))
            .cornerRadius(3)
        }
        .buttonStyle(TomeButtonStyle())
    }
 
    // MARK: - Level Up FAB
 
    private var levelUpFAB: some View {
        NavigationLink(destination: LevelUpView(character: character!)) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.tomeCrimson, Color("#A02020")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.tomeCrimson.opacity(0.5), radius: 12, x: 0, y: 4)
                VStack(spacing: 0) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.tomeParchment)
                    Text("LVL")
                        .font(.custom("Cinzel-Regular", size: 7))
                        .tracking(1)
                        .foregroundStyle(Color.tomeParchment.opacity(0.8))
                }
            }
            .frame(width: 58, height: 58)
        }
        .padding(24)
    }
 
    // MARK: - Decorative helpers
 
    private var tomeRule: some View {
        Rectangle()
            .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.4), .clear],
                                 startPoint: .leading, endPoint: .trailing))
            .frame(height: 0.8)
    }
 
    private var tomeHairline: some View {
        Rectangle()
            .fill(Color.tomeSepia.opacity(0.2))
            .frame(height: 0.8)
            .padding(.leading, 14)
    }
}
 
// MARK: - Subviews
 
struct TomeCombatStat: View {
    let icon: String
    let value: String
    let label: String
    let accentColor: Color
 
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .light))
                .foregroundStyle(accentColor.opacity(0.8))
            Text(value)
                .font(.custom("Cinzel-Bold", size: 16))
                .foregroundStyle(Color.tomeParchment)
            Text(label)
                .font(.custom("Cinzel-Regular", size: 7))
                .tracking(0.8)
                .foregroundStyle(Color.tomeMuted)
                .multilineTextAlignment(.center)
        }
    }
}
 
struct TomeResourcePill: View {
    let icon: String
    let label: String
    let color: Color
 
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 8))
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .italic()
                .foregroundStyle(Color.tomeParchment.opacity(0.85))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.7))
        .cornerRadius(2)
    }
}
 
struct TomeDetailRow: View {
    let label: String
    let value: String
 
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Cinzel-Regular", size: 10))
                .tracking(1)
                .foregroundStyle(Color.tomeMuted)
            Spacer()
            Text(value)
                .font(.custom("IMFellEnglish-Regular", size: 13))
                .italic()
                .foregroundStyle(Color.tomeParchment)
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 14)
    }
}
 
struct TomeMiniStat: View {
    let label: String
    let value: Int16
 
    var modifier: String {
        let mod = (Int(value) - 10) / 2
        return mod >= 0 ? "+\(mod)" : "\(mod)"
    }
 
    var body: some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.custom("Cinzel-Regular", size: 8))
                .tracking(2)
                .foregroundStyle(Color.tomeMuted)
            Text("\(value)")
                .font(.custom("Cinzel-Bold", size: 22))
                .foregroundStyle(Color.tomeParchment)
            Text(modifier)
                .font(.custom("Cinzel-Regular", size: 10))
                .foregroundStyle(Color.tomeGold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }
}
 
struct TomeQuickAccessLink: View {
    let destination: AnyView
    let icon: String
    let label: String
    let accent: Color
 
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(accent)
                Text(label)
                    .font(.custom("Cinzel-Regular", size: 12))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeParchment)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Color.tomeSepia)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.tomeLeather)
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
            .cornerRadius(3)
        }
        .buttonStyle(TomeButtonStyle())
    }
}
 
struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self, content: content)
            }
        }
    }
}
 
struct StatCircle: View {
    let icon: String
    let value: String
    let label: String
 
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(Color(.systemGray6))
                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1.5)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .overlay {
                            Text(value)
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundColor(.black)
                                .offset(y: 1)
                        }
                }
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
 
#Preview {}
