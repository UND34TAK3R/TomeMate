//
//  Page2.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//
import SwiftUI

struct CharacterClassView: View {
    
    @StateObject var viewModel = ClassesViewModel()
    
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @Binding var isDisabled: Bool
    
    @State private var selectedClass: ClassesModel? = nil
    @State private var sheetClass: ClassesModel? = nil
    @State private var showSheet: Bool = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select your Class")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.classes) { classes in
                        ClassCards(classes: classes, selectedClass: selectedClass)
                            .onTapGesture {
                                selectedClass = classes
                                formData.charClass = classes
                                sheetClass = classes
                                showSheet = true
                            }
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            selectedClass = formData.charClass
            if formData.subclass == nil {
                isDisabled = true
            }
            else{
                isDisabled = false
            }
        }
        .sheet(isPresented: $showSheet) {
            if let sheetClass {
                SubclassView(selectedClass: sheetClass, formData: $formData, currentPage: $currentPage)
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
  //  Page2()
}


struct ClassCards: View {
    let classes: ClassesModel
    var selectedClass: ClassesModel? = nil
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 100, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedClass == classes ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .overlay {
                VStack(spacing: 6) {
                    Spacer()
                    Text(classes.name)
                        .font(.headline)
                    Text(classes.primaryAbility)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(8)
            }
            .padding(4)
    }
}


struct SubclassView: View {
    let selectedClass: ClassesModel
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @StateObject var viewModel = SubclassesViewModel()
    @State private var selectedSubclass: SubclassModel? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Select a Subclass")
                .font(.title3)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.subclasses) { subclass in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                            .frame(width: 120, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedSubclass == subclass ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .overlay {
                                Text(subclass.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(4)
                            }
                            .onTapGesture {
                                selectedSubclass = subclass
                                formData.subclass = subclass
                                dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    currentPage += 1
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.fetchSubclasses(className: selectedClass.name)
            }
        }
    }
}
