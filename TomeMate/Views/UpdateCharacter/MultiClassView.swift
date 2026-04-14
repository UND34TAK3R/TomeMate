//
//  MultiClassView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//
import SwiftUI

struct MultiClassView: View {
    let character: Character?
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = ClassesViewModel()
    @State private var selectedClass: ClassesModel? = nil
    @State private var selectedSubclass: SubclassModel? = nil
    @State private var sheetClass: ClassesModel? = nil
    @State private var showSheet: Bool = false

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var canConfirm: Bool { selectedClass != nil && selectedSubclass != nil }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Multiclass")
                            .font(.custom("Cinzel-Regular", size: 20))
                            .foregroundStyle(Color.tomeParchment)
                        DecorativeRuleView().padding(.horizontal, 60)
                        Text("Select a new class to add")
                            .font(.custom("IMFellEnglish-Regular", size: 12))
                            .italic()
                            .foregroundStyle(Color.tomeMuted)
                    }
                    .padding(.vertical, 20)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.classes) { cls in
                            TomeClassCard(cls: cls, isSelected: selectedClass == cls)
                                .onTapGesture {
                                    selectedClass = cls
                                    selectedSubclass = nil
                                    sheetClass = cls
                                    showSheet = true
                                }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Selected summary
                    if let cls = selectedClass {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(LinearGradient(colors: [.clear, Color.tomeSepia.opacity(0.3), .clear],
                                                     startPoint: .leading, endPoint: .trailing))
                                .frame(height: 0.8)
                                .padding(.horizontal, 16)
                                .padding(.top, 20)

                            HStack(spacing: 14) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(cls.name)
                                        .font(.custom("Cinzel-Regular", size: 14))
                                        .foregroundStyle(Color.tomeParchment)
                                    if let sub = selectedSubclass {
                                        Text(sub.name)
                                            .font(.custom("IMFellEnglish-Regular", size: 12))
                                            .italic()
                                            .foregroundStyle(Color.tomeGold)
                                    } else {
                                        Text("No subclass selected")
                                            .font(.custom("IMFellEnglish-Regular", size: 12))
                                            .italic()
                                            .foregroundStyle(Color.tomeCrimsonLight)
                                    }
                                }
                                Spacer()
                                Button {
                                    sheetClass = cls
                                    showSheet = true
                                } label: {
                                    Text("Change Subclass")
                                        .font(.custom("Cinzel-Regular", size: 9))
                                        .tracking(1)
                                        .foregroundStyle(Color.tomeGold)
                                        .padding(.horizontal, 10).padding(.vertical, 6)
                                        .background(Color.tomeGold.opacity(0.1))
                                        .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(Color.tomeGold.opacity(0.3), lineWidth: 0.7))
                                        .cornerRadius(2)
                                }
                                .buttonStyle(TomeButtonStyle())
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 14)
                        }
                    }

                    Spacer(minLength: 100)
                }
                .padding(.bottom, 20)
            }

            VStack(spacing: 0) {
                LinearGradient(colors: [Color.tomeBg.opacity(0), Color.tomeBg],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
                SealButton(canConfirm ? "Confirm Multiclass" : "Select Class & Subclass", isLoading: false) {
                    guard let cls = selectedClass, let sub = selectedSubclass, let character else { return }
                    holder.multiclass(character: character, selectedClass: cls, selectedSubclass: sub, context)
                    dismiss()
                }
                .disabled(!canConfirm)
                .opacity(canConfirm ? 1 : 0.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
                .background(Color.tomeBg)
            }
        }
        .sheet(isPresented: $showSheet) {
            if let sheetClass {
                TomeSubclassSheet(selectedClass: sheetClass, selectedSubclass: $selectedSubclass)
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationTitle("Multiclass")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Class Card
private struct TomeClassCard: View {
    let cls: ClassesModel
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(cls.name)
                .font(.custom("Cinzel-Regular", size: 11))
                .tracking(0.5)
                .foregroundStyle(isSelected ? Color.tomeParchment : Color.tomeMuted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(cls.primaryAbility)
                .font(.custom("IMFellEnglish-Regular", size: 9))
                .italic()
                .foregroundStyle(isSelected ? Color.tomeGold : Color.tomeSepia.opacity(0.6))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .padding(.horizontal, 6)
        .background(isSelected ? Color.tomeGold.opacity(0.08) : Color.tomeLeather)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(isSelected ? Color.tomeGold.opacity(0.5) : Color.tomeSepia.opacity(0.3), lineWidth: isSelected ? 1.2 : 0.8)
        )
        .cornerRadius(3)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Subclass Sheet
private struct TomeSubclassSheet: View {
    let selectedClass: ClassesModel
    @Binding var selectedSubclass: SubclassModel?
    @StateObject var viewModel = SubclassesViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Select Subclass".uppercased())
                        .font(.custom("Cinzel-Regular", size: 9))
                        .tracking(2)
                        .foregroundStyle(Color.tomeMuted)
                    Text(selectedClass.name)
                        .font(.custom("Cinzel-Regular", size: 16))
                        .foregroundStyle(Color.tomeParchment)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.subclasses) { subclass in
                            let isSelected = selectedSubclass == subclass
                            Text(subclass.name)
                                .font(.custom("IMFellEnglish-Regular", size: isSelected ? 13 : 12))
                                .italic()
                                .foregroundStyle(isSelected ? Color.tomeInk : Color.tomeParchment)
                                .padding(.horizontal, 14).padding(.vertical, 10)
                                .background(isSelected ? Color.tomeGold : Color.tomeLeather)
                                .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(isSelected ? Color.tomeGold : Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
                                .cornerRadius(2)
                                .onTapGesture {
                                    selectedSubclass = subclass
                                    dismiss()
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear { viewModel.fetchSubclasses(className: selectedClass.name) }
    }
}
