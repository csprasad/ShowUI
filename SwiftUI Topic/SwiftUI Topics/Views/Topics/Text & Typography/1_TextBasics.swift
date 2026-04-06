//
//
//  1_TextBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Text Basics
struct TextBasicsVisual: View {
    @State private var selectedWeight: Font.Weight = .regular
    @State private var selectedDesign: Font.Design = .default
    
    let weights: [(String, Font.Weight)] = [("Light", .light), ("Reg", .regular), ("Med", .medium), ("Bold", .bold), ("Black", .black)]
    let designs: [Font.Design] = [.default, .rounded, .monospaced, .serif]
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Font Lab", systemImage: "textformat.size")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#1D9E75"))

                VStack {
                    Text("The quick brown fox")
                        .font(.system(size: 24, weight: selectedWeight, design: selectedDesign))
                        .animation(.spring(response: 0.3), value: selectedWeight)
                }
                .frame(maxWidth: .infinity).frame(height: 80)
                .background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Weight").font(.caption).bold().foregroundStyle(.secondary)
                    HStack {
                        ForEach(weights, id: \.0) { name, weight in
                            Button(name) { selectedWeight = weight }
                                .font(.system(size: 11))
                                .padding(.horizontal, 8).padding(.vertical, 6)
                                .background(selectedWeight == weight ? Color(hex: "#1D9E75") : Color(.systemFill))
                                .foregroundStyle(selectedWeight == weight ? .white : .primary)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text("Design").font(.caption).bold().foregroundStyle(.secondary)
                    HStack {
                        ForEach(designs, id: \.self) { design in
                            Button(String(describing: design).capitalized) { selectedDesign = design }
                                .font(.system(size: 11))
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                                .background(selectedDesign == design ? Color(hex: "#1D9E75") : Color(.systemFill))
                                .foregroundStyle(selectedDesign == design ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
    }
}

struct TextBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Standard Typography")
            Text("SwiftUI uses a semantic type system that automatically scales with accessibility settings. You can customize the 'personality' of text using weights and design styles.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".font(.system(size:weight:design:)) is the primary way to style text.", color: Color(hex: "#1D9E75"))
                StepRow(number: 2, text: "Design styles include .default, .rounded, .monospaced, and .serif.", color: Color(hex: "#1D9E75"))
                StepRow(number: 3, text: "Weights range from .ultraLight to .black.", color: Color(hex: "#1D9E75"))
            }

            CodeBlock(code: """
Text("Hello")
    .font(.system(size: 20, weight: .bold, design: .rounded))
""")
        }
    }
}
