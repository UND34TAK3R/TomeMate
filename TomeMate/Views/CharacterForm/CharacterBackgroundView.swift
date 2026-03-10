//
//  Page4.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import SwiftUI

struct CharacterBackgroundView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @StateObject var viewModel = BackgroundViewModel()
    @State private var selectedBackground: BackgroundModel? = nil
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack(alignment: .center){
            Text("Select your Background")
                .font(.title)
                .bold()
                .padding(.vertical, 10)
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(viewModel.backgrounds){
                        background in
                        BackgroundCard(background: background, selectedBackground: selectedBackground)
                            .onTapGesture {
                                selectedBackground = background
                                formData.background = background
                            }.padding()
                    }
                }
            }
        }
        .onAppear{
            selectedBackground = formData.background
            if selectedBackground?.name == "" {
                isDisabled = true
            }
            else{
                isDisabled = false
            }
        }
        .onChange(of: formData.background){
            isDisabled = false
        }
    }
}


struct BackgroundCard: View {
    let background: BackgroundModel
    var selectedBackground: BackgroundModel? = nil
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width:175, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedBackground == background ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .overlay {
                VStack(spacing: 6) {
                    Spacer()
                    Text(background.name)
                        .font(.headline)
                    Text(background.skillProficiencies.joined(separator: "/"))
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(8)
            }
            .padding(4)
    }
}

#Preview {
   // Page4()
}
