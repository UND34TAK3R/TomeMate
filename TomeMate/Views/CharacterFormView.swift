//
//  CharacterFormView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import SwiftUI

struct CharacterFormView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @State private var formData = CharacterFormData()
    @State private var isDisabled: Bool = false
    @State private var currentPage: Int = 0        // add default value
    @State var character: Character? = nil
    @State var stats: Stats? = nil
    @State var skills: [SkillProficiencies] = []
    @State var charClass: Classes? = nil
    @State var isCharacter: Bool = false
    
    var body: some View {
        VStack {                                    // wrap in VStack
            TabView(selection: $currentPage) {
                CharacterNameView(formData: $formData, isDisabled: $isDisabled).tag(0)
                CharacterClassView(formData: $formData, currentPage: $currentPage, isDisabled: $isDisabled).tag(1)
                CharacterRaceView(formData: $formData, currentPage: $currentPage, isDisabled: $isDisabled).tag(2)
                CharacterBackgroundView(formData: $formData, isDisabled: $isDisabled).tag(3)
                SkillProficienciesView(formData: $formData,isDisabled: $isDisabled).tag(4)
                StatsView(formData: $formData, isDisabled: $isDisabled).tag(5)
                AlignmentView(formData: $formData, isDisabled: $isDisabled).tag(6)
                AgeView(formData: $formData, isDisabled: $isDisabled).tag(7)
                LanguageView(formData: $formData, isDisabled: $isDisabled).tag(8)
                ExperienceView(formData: $formData, isDisabled: $isDisabled).tag(9)
                ConfirmationPage().tag(10)
            }
            .onChange(of: currentPage) { _ in
                UIApplication.shared.dismissKeyboard()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack(spacing: 5) {
                Button {
                    currentPage -= 1
                } label: {
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 40, height: 40)
                        .overlay {
                            VStack{
                                Image(systemName: "chevron.left")
                                    .frame(width: 20, height: 20)
                            }
                        }
                }
                .disabled(currentPage == 0)
                .padding()
                
                Spacer()
                
                ProgressView(value: Double(currentPage + 1), total: 11)
                    .foregroundStyle(Color(.red))
                
                Spacer()
                
                Button {
                    if currentPage == 10{
                        isCharacter = true
                        stats = holder.createStat(formData: formData, context)
                        skills = holder.createSkill(formData: formData, context)
                        charClass = holder.createClass(classes: formData.charClass!, subclass: formData.subclass!, context)
                        Task{
                            character = await holder.createCharacter(formData: formData, stat: stats!, skills: skills, classes: charClass!, context)
                        }
                        
                    }else{
                        currentPage += 1
                    }
                } label: {
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 40, height: 40)
                        .overlay {
                            VStack{
                                Image(systemName: "chevron.right")
                                    .frame(width: 20, height: 20)
                                
                            }
                        }
                }
                .disabled(isDisabled)
                .navigationDestination(isPresented: $isCharacter){
                    CharacterOverviewView(character: character)
                }
                .padding()
            }
            if(currentPage == 10){
                HStack{
                    Spacer()
                    Text("Confirm")
                        .font(Font.system(size: 14, design: .default))
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
        }
    }
}
#Preview {
    //CharacterFormView()
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
