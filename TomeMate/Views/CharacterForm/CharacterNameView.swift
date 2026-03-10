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
        VStack{
            Spacer()
            Text("What is your name adventurer?")
                .font(.title)
                .bold()
                .padding()
            TextField("", text: $formData.name)
                .multilineTextAlignment(.center)
                .frame(width: 250)
                .focused($isNameFocused)
                .submitLabel(.done)
                .onSubmit {
                    isNameFocused = false
                }
                .onChange(of: formData.name){
                    if formData.name.isEmpty{
                        isDisabled = true
                    }
                    else{
                        isDisabled = false
                    }
                }
            Rectangle()
                .frame(width: 250, height: 1)
                .foregroundStyle(Color.gray)
            Spacer()
        }
        .onAppear(){
            if formData.name.isEmpty{
                isDisabled = true
            }
            else{
                isDisabled = false
            }
        }
        .onDisappear{
            isNameFocused = false
        }
    }
}

#Preview {
    
}
