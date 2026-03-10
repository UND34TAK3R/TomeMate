//
//  Page7.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//

import SwiftUI

struct AlignmentView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State private var alignmentValue1: Double = 1
    @State private var alignmentValue2: Double = 1
    var alignmentText1: String {
        switch Int(alignmentValue1){
            case 0: return "Good"
            case 1: return "Neutral"
            case 2: return "Evil"
            default: return ""
        }
    }
    var alignmentText2: String {
        switch Int(alignmentValue2){
            case 0: return "Lawful"
            case 1: return "Neutral"
            case 2: return "Chaotic"
            default: return ""
        }
    }
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text("What is your alignment?")
                .font(Font.largeTitle.bold())
                .padding()
            Spacer()
            Text("Neutral")
                Slider(
                    value: $alignmentValue1,
                    in: 0...2,
                    step: 1,
                    label:{
                      Text("Neutral")
                    },
                    minimumValueLabel: {
                        Text("Good")
                    },
                    maximumValueLabel: {
                        Text("Evil")
                    }
                )
                .padding()
            Spacer()
            Text("Neutral")
                Slider(
                    value: $alignmentValue2,
                    in: 0...2,
                    step: 1,
                    label:{
                      Text("Neutral")
                    },
                    minimumValueLabel: {
                        Text("Lawful")
                    },
                    maximumValueLabel: {
                        Text("Chaotic")
                    }
                )
                .padding()
            Spacer()
        }
        .onAppear{
            isDisabled = false
            if formData.alignment.isEmpty{
                self.alignmentValue1 = 1
                self.alignmentValue2 = 1
            }
        }
        .onDisappear{
            formData.alignment = "\(self.alignmentText1) - \(self.alignmentText2)"
        }
    }
}

#Preview {
//    Page7()
}
