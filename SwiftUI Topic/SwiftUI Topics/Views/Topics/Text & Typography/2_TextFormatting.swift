//
//
//  2_TextFormatting.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `04/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Text Formatting
struct TextFormattingVisual: View {
    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Markdown & Links", systemImage: "bold.italic.underline")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#1D9E75"))

                VStack(alignment: .leading, spacing: 12) {
                    Text("This is **Bold**, *Italic*, and ~~Strikethrough~~.")
                    Text("You can also add [Links](https://apple.com) easily.")
                    Text("Combine them: ***[Bold Link](https://swift.org)***")
                }
                .font(.system(size: 15))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                CalloutBox(style: .info, title: "Markdown Tip", contentBody: "SwiftUI handles basic Markdown automatically when using String literals.")
            }
        }
    }
}

struct TextFormattingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Rich Text Formatting")
            Text("Since iOS 15, SwiftUI supports Markdown out of the box. This allows for rich text without needing complex AttributedString code for simple cases.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Use **text** for bold.", color: Color(hex: "#1D9E75"))
                StepRow(number: 2, text: "Use *text* for italic.", color: Color(hex: "#1D9E75"))
                StepRow(number: 3, text: "Use [title](url) for clickable links.", color: Color(hex: "#1D9E75"))
            }

            CodeBlock(code: """
Text("Check out **[ShowUI](https://github.com)**!")
""")
        }
    }
}
