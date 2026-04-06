//
//
//  3_TextTruncation.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 3: Text Truncation
struct TextTruncationVisual: View {
    @State private var lineLimit = 1
    @State private var truncationMode: Text.TruncationMode = .tail
    
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Truncation Lab", systemImage: "text.append")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#1D9E75"))

                Text("This is a very long piece of text that demonstrates how SwiftUI handles overflow when space is limited.")
                    .font(.system(size: 16))
                    .lineLimit(lineLimit)
                    .truncationMode(truncationMode)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 12) {
                    Stepper("Line Limit: \(lineLimit)", value: $lineLimit, in: 1...3)
                    
                    Picker("Mode", selection: $truncationMode) {
                        Text("Tail").tag(Text.TruncationMode.tail)
                        Text("Middle").tag(Text.TruncationMode.middle)
                        Text("Head").tag(Text.TruncationMode.head)
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}

struct TextTruncationExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Limits & Truncation")
            Text("Control how text behaves when it exceeds its container size.")
                .font(.system(size: 15)).foregroundStyle(.secondary)
            
            StepRow(number: 1, text: ".lineLimit(n) restricts text to a specific number of lines.", color: Color(hex: "#1D9E75"))
            StepRow(number: 2, text: ".truncationMode determines where the '...' appears.", color: Color(hex: "#1D9E75"))
            
            CodeBlock(code: """
Text("Long string...")
    .lineLimit(2)
    .truncationMode(.middle)
""")
        }
    }
}
