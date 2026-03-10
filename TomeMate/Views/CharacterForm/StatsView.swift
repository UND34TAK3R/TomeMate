//
//  Page6.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-01.
//

import SwiftUI

import SwiftUI

struct StatsView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @State private var strvalue: Double = 10
    @State private var dexvalue: Double = 10
    @State private var convalue: Double = 10
    @State private var wisvalue: Double = 10
    @State private var intvalue: Double = 10
    @State private var chavalue: Double = 10

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text("Stats")
                    .font(.title)
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("Strength")
                .font(.headline)
            HStack {
                Slider(
                    value: $strvalue,
                    in: 0...20,
                    step: 1,
                    label: {Text("label")},
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("20") }
                )
                .onChange(of: strvalue){ newvalue in
                    strvalue = Double(Int(newvalue.rounded()))
                }
                .padding()

                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .background(Circle().fill(Color.white))
                            .frame(width: 44, height: 44)
                        Text("\(Int($strvalue.wrappedValue))")
                            .font(.title3)
                    }
                    Text(returnModifier(value: $strvalue.wrappedValue))
                        .font(.caption)
                }
                .padding(.trailing)
            }
            Text("Dexterity")
                .font(.headline)
            HStack {
                Slider(
                    value: $dexvalue,
                    in: 0...20,
                    step: 1,
                    label: {Text("label")},
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("20") }
                )
                .onChange(of: dexvalue){ newvalue in
                    dexvalue = Double(Int(newvalue.rounded()))
                }
                .padding()

                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .background(Circle().fill(Color.white))
                            .frame(width: 44, height: 44)
                        Text("\(Int($dexvalue.wrappedValue))")
                            .font(.title3)
                    }
                    Text(returnModifier(value: $dexvalue.wrappedValue))
                        .font(.caption)
                }
                .padding(.trailing)
            }
            Text("Constitution")
                .font(.headline)
            HStack {
                Slider(
                    value: $convalue,
                    in: 0...20,
                    step: 1,
                    label: {Text("label")},
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("20") }
                )
                .onChange(of: convalue){ newvalue in
                    convalue = Double(Int(newvalue.rounded()))
                }
                .padding()

                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .background(Circle().fill(Color.white))
                            .frame(width: 44, height: 44)
                        Text("\(Int($convalue.wrappedValue))")
                            .font(.title3)
                    }
                    Text(returnModifier(value: $convalue.wrappedValue))
                        .font(.caption)
                }
                .padding(.trailing)
            }
            Text("Intelligence")
                .font(.headline)
            HStack {
                Slider(
                    value: $intvalue,
                    in: 0...20,
                    step: 1,
                    label: {Text("label")},
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("20") }
                )
                .onChange(of: intvalue){ newvalue in
                    intvalue = Double(Int(newvalue.rounded()))
                }
                .padding()

                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .background(Circle().fill(Color.white))
                            .frame(width: 44, height: 44)
                        Text("\(Int($intvalue.wrappedValue))")
                            .font(.title3)
                    }
                    Text(returnModifier(value: $intvalue.wrappedValue))
                        .font(.caption)
                }
                .padding(.trailing)
            }
            Text("Wisdom")
                .font(.headline)
            HStack {
                Slider(
                    value: $wisvalue,
                    in: 0...20,
                    step: 1,
                    label: {Text("label")},
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("20") }
                )
                .onChange(of: wisvalue){ newvalue in
                    wisvalue = Double(Int(newvalue.rounded()))
                }
                .padding()

                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .background(Circle().fill(Color.white))
                            .frame(width: 44, height: 44)
                        Text("\(Int($wisvalue.wrappedValue))")
                            .font(.title3)
                    }
                    Text(returnModifier(value: $wisvalue.wrappedValue))
                        .font(.caption)
                }
                .padding(.trailing)
            }
            Text("Charisma")
                .font(.headline)
            HStack {
                Slider(
                    value: $chavalue,
                    in: 0...20,
                    step: 1,
                    label: {Text("label")},
                    minimumValueLabel: { Text("0") },
                    maximumValueLabel: { Text("20") }
                )
                .onChange(of: chavalue){ newvalue in
                    chavalue = Double(Int(newvalue.rounded()))
                }
                .padding()

                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 1)
                            .background(Circle().fill(Color.white))
                            .frame(width: 44, height: 44)
                        Text("\(Int($chavalue.wrappedValue))")
                            .font(.title3)
                    }
                    Text(returnModifier(value: $chavalue.wrappedValue))
                        .font(.caption)
                }
                .padding(.trailing)
            }
        }
        .onAppear {
            isDisabled = false
            if formData.strength != 10    { strvalue = Double(formData.strength) }
            if formData.dexterity != 10   { dexvalue = Double(formData.dexterity) }
            if formData.constitution != 10 { convalue = Double(formData.constitution) }
            if formData.intelligence != 10 { intvalue = Double(formData.intelligence) }
            if formData.wisdom != 10      { wisvalue = Double(formData.wisdom) }
            if formData.charisma != 10    { chavalue = Double(formData.charisma) }
        }
        .onDisappear {
            formData.strength     = Int(strvalue)
            formData.dexterity    = Int(dexvalue)
            formData.constitution = Int(convalue)
            formData.intelligence = Int(intvalue)
            formData.wisdom       = Int(wisvalue)
            formData.charisma     = Int(chavalue)
        }
    }
    
    private func returnModifier(value: Double) -> String {
        var modifer = Int(floor(Double((value - 10) / 2)))
        if modifer > 10 {
            return "+ \(modifer)"
        } else {
            return "\(modifer)"
        }
    }
}
