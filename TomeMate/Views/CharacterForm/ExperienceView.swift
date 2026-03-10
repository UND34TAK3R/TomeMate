//
//  Page10.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//

import SwiftUI

struct ExperienceView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State var isXP : Bool = false
    @State var isMilestone: Bool = false
    var body: some View {
        VStack(alignment:.center){
            Spacer()
            Text("How are you leveling up ?")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 30)
            Toggle("Experience Based Leveling:", isOn: $isXP)
                .padding()
            Toggle("Milestone Based Leveling:", isOn: $isMilestone)
                .padding()
            Spacer()
        }
        .onAppear{
            if isXP == false && isMilestone == false{
                isDisabled = true
            }
        }
        .onChange(of: isXP){
            if isXP == true {
                isMilestone = false
                isDisabled = false
            }
            if isXP == false && isMilestone == false{
                isDisabled = true
            }
        }
        .onChange(of: isMilestone){
            if isMilestone == true {
                isXP = false
                isDisabled = false
            }
            if isXP == false && isMilestone == false{
                isDisabled = true
            }
        }
        .onDisappear{
            if isXP == true {
                formData.xp = true
            }
            else{
                formData.xp = false
            }
        }
    }
}

#Preview {
   // Page10()
}
