//
//  HomebrewComponents.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-04-12.
//

import SwiftUI

// MARK: - Section wrapper

struct HomebrewSection<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content

    init(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .light))
                    .foregroundStyle(Color.tomeCrimson.opacity(0.7))
                Rectangle()
                    .fill(Color.tomeCrimson.opacity(0.6))
                    .frame(width: 2, height: 12)
                    .cornerRadius(1)
                Text(title.uppercased())
                    .font(.custom("Cinzel-Regular", size: 9))
                    .tracking(2.5)
                    .foregroundStyle(Color.tomeMuted)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tomeSpine)

            content()
        }
        .background(Color.tomeLeather)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Color.tomeSepia.opacity(0.3), lineWidth: 0.8))
        .cornerRadius(3)
    }
}

// MARK: - Text field row

struct HomebrewTextField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(Color.tomeSepia)
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 3) {
                Text(label.uppercased())
                    .font(.custom("Cinzel-Regular", size: 8))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeSepia)
                TextField(placeholder, text: $text)
                    .font(.custom("IMFellEnglish-Regular", size: 14))
                    .foregroundStyle(Color.tomeParchment)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Text editor row

struct HomebrewTextEditor: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(Color.tomeSepia)
                .frame(width: 16)
                .padding(.top, 14)
            VStack(alignment: .leading, spacing: 3) {
                Text(label.uppercased())
                    .font(.custom("Cinzel-Regular", size: 8))
                    .tracking(1.5)
                    .foregroundStyle(Color.tomeSepia)
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.custom("IMFellEnglish-Regular", size: 14))
                            .italic()
                            .foregroundStyle(Color.tomeParchment.opacity(0.3))
                            .padding(.top, 8)
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: $text)
                        .font(.custom("IMFellEnglish-Regular", size: 14))
                        .foregroundStyle(Color.tomeParchment)
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

// MARK: - Picker row

struct HomebrewPicker<Content: View>: View {
    let label: String
    let icon: String
    let picker: () -> Content

    init(label: String, icon: String, @ViewBuilder picker: @escaping () -> Content) {
        self.label = label
        self.icon = icon
        self.picker = picker
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(Color.tomeSepia)
                .frame(width: 16)
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .foregroundStyle(Color.tomeParchment)
            Spacer()
            picker()
                .font(.custom("IMFellEnglish-Regular", size: 13))
                .foregroundStyle(Color.tomeGold)
                .tint(Color.tomeGold)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

// MARK: - Toggle row

struct HomebrewToggleRow: View {
    let label: String
    let icon: String
    @Binding var value: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(Color.tomeSepia)
                .frame(width: 16)
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 14))
                .foregroundStyle(Color.tomeParchment)
            Spacer()
            // Custom tome-styled toggle
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { value.toggle() }
            } label: {
                ZStack(alignment: value ? .trailing : .leading) {
                    Capsule()
                        .fill(value ? Color.tomeCrimson : Color.tomeSpine)
                        .overlay(Capsule().strokeBorder(value ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4), lineWidth: 0.8))
                        .frame(width: 44, height: 26)
                    Circle()
                        .fill(value ? Color.tomeParchment : Color.tomeMuted)
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 3)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
            }
            .buttonStyle(TomeButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Active filter chip (used in AddSpell/AddItem)

struct TomeActiveFilterChip: View {
    let label: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.custom("IMFellEnglish-Regular", size: 11))
                .italic()
                .foregroundStyle(Color.tomeInk)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(Color.tomeInk.opacity(0.6))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.tomeGold.opacity(0.75))
        .cornerRadius(2)
    }
}
