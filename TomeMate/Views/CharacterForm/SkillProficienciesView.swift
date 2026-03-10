//
//  Page5.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import SwiftUI

struct SkillProficienciesView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @StateObject var viewModel = SkillsViewModel()
    @State var skills: [SkillsModel] = []
    @State var manualSelections: Set<String> = []
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    func applyProficiencies(_ skillList: [SkillsModel]) -> [SkillsModel] {
        skillList.map { skill in
            var s = skill
            let isBackgroundProficient = formData.background.skillProficiencies
                .map({ $0.lowercased().trimmingCharacters(in: .whitespaces) })
                .contains(skill.name.lowercased().trimmingCharacters(in: .whitespaces))
            s.isProficient = manualSelections.contains(skill.name) || isBackgroundProficient
            return s
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            Text("Select your Skills")
                .font(.title)
                .bold()
                .padding(.vertical, 10)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach($skills) { $skill in
                        SkillsCard(skill: $skill, formData: $formData) {
                            if manualSelections.contains(skill.name) {
                                manualSelections.remove(skill.name)
                            } else {
                                manualSelections.insert(skill.name)
                            }
                            skills = applyProficiencies(skills)
                        }
                    }
                }
            }
        }
        .onDisappear {
            formData.skills = skills
        }
        .onAppear {
            isDisabled = false
            // Restore manual selections from saved skills that weren't background proficient
            let backgroundProficiencies = formData.background.skillProficiencies
                .map({ $0.lowercased().trimmingCharacters(in: .whitespaces) })
            if !formData.skills.isEmpty {
                manualSelections = Set(
                    formData.skills
                        .filter { skill in
                            skill.isProficient &&
                            !backgroundProficiencies.contains(skill.name.lowercased().trimmingCharacters(in: .whitespaces))
                        }
                        .map { $0.name }
                )
                skills = applyProficiencies(formData.skills)
            } else {
                viewModel.fetchSkills()
            }
        }
        .onChange(of: viewModel.skills) { newSkills in
            skills = applyProficiencies(newSkills)
        }
        .onChange(of: formData.background.skillProficiencies) { _ in
            formData.skills.removeAll()
            skills = applyProficiencies(skills)
        }
    }
}

struct SkillsCard: View {
    @Binding var skill: SkillsModel
    @Binding var formData: CharacterFormData
    let onTap: () -> Void
    var body: some View {
        HStack {
            Text("\(skill.name) (\(skill.ability))")
            Spacer()
            ZStack {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: 20, height: 20)
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.blue)
                    .scaleEffect(skill.isProficient ? 1 : 0)
            }
        }
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}
