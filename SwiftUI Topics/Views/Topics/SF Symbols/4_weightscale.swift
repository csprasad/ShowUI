//
//
//  4_ weightscale.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Font Weight & Scale

struct WeightScaleVisual: View {
    @State private var selectedWeight = 4  // regular
    @State private var selectedScale  = 1  // medium
    @State private var selectedSymbol = "star.fill"

    let weights: [(name: String, weight: Font.Weight)] = [
        ("ultraLight", .ultraLight), ("thin", .thin), ("light", .light),
        ("regular", .regular), ("medium", .medium), ("semibold", .semibold),
        ("bold", .bold), ("heavy", .heavy), ("black", .black),
    ]

    let scales: [(name: String, scale: Image.Scale)] = [
        ("small", .small), ("medium", .medium), ("large", .large)
    ]

    let symbols = ["star.fill", "heart.fill", "bolt.fill", "leaf.fill",
                   "flame.fill", "drop.fill", "moon.fill", "sun.max.fill"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Font weight & scale", systemImage: "textformat.size")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Live preview — all 3 scales at current weight
                ZStack {
                    Color(.secondarySystemBackground)
                    HStack(spacing: 24) {
                        ForEach(scales.indices, id: \.self) { i in
                            VStack(spacing: 6) {
                                Image(systemName: selectedSymbol)
                                    .font(.system(size: 32, weight: weights[selectedWeight].weight))
                                    .imageScale(scales[i].scale)
                                    .foregroundStyle(Color.sfGreen)
                                Text(".\(scales[i].name)")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(i == selectedScale ? Color.sfGreen : .secondary)
                            }
                            .padding(.horizontal, 10).padding(.vertical, 8)
                            .background(i == selectedScale ? Color.sfGreenLight : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture { withAnimation(.spring(response: 0.3)) { selectedScale = i } }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Weight scrubber
                VStack(alignment: .leading, spacing: 6) {
                    Text("Weight: .\(weights[selectedWeight].name)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(Color.sfGreen)

                    // All weights shown as a row of the same symbol
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(weights.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.25)) { selectedWeight = i }
                                } label: {
                                    VStack(spacing: 3) {
                                        Image(systemName: selectedSymbol)
                                            .font(.system(size: 22, weight: weights[i].weight))
                                            .foregroundStyle(selectedWeight == i ? Color.sfGreen : .secondary)
                                            .frame(width: 36, height: 36)
                                            .background(selectedWeight == i ? Color.sfGreenLight : Color(.systemFill))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        Text(String(weights[i].name.prefix(4)))
                                            .font(.system(size: 8))
                                            .foregroundStyle(selectedWeight == i ? Color.sfGreen : Color(.tertiaryLabel))
                                    }
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }
                }

                // Symbol switcher
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(symbols, id: \.self) { sym in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedSymbol = sym }
                            } label: {
                                Image(systemName: sym)
                                    .font(.system(size: 18))
                                    .foregroundStyle(selectedSymbol == sym ? Color.sfGreen : .secondary)
                                    .frame(width: 36, height: 36)
                                    .background(selectedSymbol == sym ? Color.sfGreenLight : Color(.systemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

struct WeightScaleExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Weight and scale")
            Text("SF Symbols inherit their weight from the surrounding font — they're designed to match text optically. imageScale adjusts the symbol's size relative to the surrounding text without changing the font size.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Font weight — use .font(.system(size:weight:)) to set the symbol's stroke weight. It matches the same weight as text.", color: .sfGreen)
                StepRow(number: 2, text: ".imageScale(.small / .medium / .large) — sizes the symbol at 75%, 100%, or 125% of the surrounding text size.", color: .sfGreen)
                StepRow(number: 3, text: "Symbols in a Label or HStack alongside Text automatically inherit the text font and align optically.", color: .sfGreen)
                StepRow(number: 4, text: ".fontWeight() alone works too — symbols inherit it from the text environment.", color: .sfGreen)
            }

            CalloutBox(style: .success, title: "Optical sizing", contentBody: "SF Symbols are designed at each weight so they look proportionally correct alongside same-weight text. Don't manually adjust symbol size to match text — let the font system do it.")

            CalloutBox(style: .info, title: "imageScale vs font size", contentBody: ".imageScale changes the symbol's size relative to the text context. Setting an explicit font size directly on the Image overrides this and removes the optical alignment benefit.")

            CodeBlock(code: """
// Weight follows font
Label("Download", systemImage: "arrow.down.circle.fill")
    .font(.system(size: 16, weight: .semibold))
// Symbol automatically renders at semibold weight

// imageScale for relative sizing
HStack {
    Image(systemName: "star.fill")
        .imageScale(.large)   // 125% of text size
    Text("Featured")
        .font(.body)
}

// Explicit weight on symbol
Image(systemName: "bolt.fill")
    .font(.system(size: 24, weight: .black))

// Environment-based — all symbols in this view get bold
VStack {
    Image(systemName: "heart.fill")
    Image(systemName: "star.fill")
}
.fontWeight(.bold)
""")
        }
    }
}
