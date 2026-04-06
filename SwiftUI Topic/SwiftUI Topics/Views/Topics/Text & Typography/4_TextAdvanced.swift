//
//
//  4_TextAdvanced.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 4: Text Advance
struct TextAdvancedVisual: View {
    @State private var kerning: CGFloat = 0
    @State private var lineSpacing: CGFloat = 0
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Advanced Lab", systemImage: "character.cursor.ibeam")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#1D9E75"))

                VStack(alignment: .leading) {
                    Text("Typography Design")
                        .font(.system(size: 22, weight: .bold))
                        .kerning(kerning)
                    
                    Text("Line spacing affects how multiple lines of text are separated vertically for better readability.")
                        .font(.system(size: 14))
                        .lineSpacing(lineSpacing)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 8) {
                    HStack {
                        Text("Kerning").font(.caption)
                        Slider(value: $kerning, in: 0...10)
                    }
                    HStack {
                        Text("Spacing").font(.caption)
                        Slider(value: $lineSpacing, in: 0...20)
                    }
                }
            }
        }
    }
}

struct TextAdvancedExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Precision Styling")
            StepRow(number: 1, text: ".kerning(n) adds fixed spacing between characters.", color: Color(hex: "#1D9E75"))
            StepRow(number: 2, text: ".lineSpacing(n) adds vertical space between lines of text.", color: Color(hex: "#1D9E75"))
            
            CodeBlock(code: """
Text("Modern UI")
    .kerning(2.0)
    .lineSpacing(10)
""")
        }
    }
}
