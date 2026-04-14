//
//  NameView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-02.
//

import SwiftUI

struct CharacterNameView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @FocusState private var isNameFocused: Bool
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {
                Spacer()

                Text("What is your name,")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)

                Text("Adventurer?")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                TomeTextField(
                    label: "Name",
                    icon: "person",
                    placeholder: "Enter your name",
                    text: $formData.name
                )
                .padding(.horizontal, 32)

                Spacer()
            }
        }
        .onAppear(){
            if formData.name.isEmpty{
                isDisabled = true
            }
        }
        .onChange(of: formData.name) { _, newValue in
            isDisabled = newValue.isEmpty
        }
        .onDisappear{
            isNameFocused = false
        }
    }
}

#Preview {
    
}
