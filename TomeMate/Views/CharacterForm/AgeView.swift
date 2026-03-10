//
//  Page2.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-27.
//

import SwiftUI

struct AgeView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State private var ageText: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("How old are you?")
                .font(.title)
                .bold()
                .padding()
            TextField("", text: $ageText)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onChange(of: ageText) {
                    if let age = Int(ageText), age > 0 {
                        formData.age = age
                        isDisabled = false
                    } else {
                        formData.age = 0
                        isDisabled = true
                    }
                }
                .frame(width: 250)
            Rectangle()
                .frame(width: 250, height: 1)
                .foregroundStyle(Color.gray)
            Spacer()
        }
        .onAppear {
            if formData.age == 0 {
                isDisabled = true
            }
            else{
                ageText = String(formData.age)
                isDisabled = false
            }
        }
    }
}

#Preview {

}
