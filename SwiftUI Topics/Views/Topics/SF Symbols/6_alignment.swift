//
//
//  6_alignment.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: Symbol Alignment
struct AlignmentVisual: View {
    @State private var selectedDemo = 0
    @State private var fontSize: CGFloat = 17

    let demos = ["Baseline", "Center", "Custom offset"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Symbol alignment", systemImage: "text.alignleft")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.sfGreen : .secondary)
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedDemo == i ? Color.sfGreenLight : Color(.systemFill))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)

                    // Baseline guide
                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)

                    switch selectedDemo {
                    case 0:
                        // Correct baseline alignment
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: fontSize))
                                .foregroundStyle(Color.sfGreen)
                            Text("Featured content")
                                .font(.system(size: fontSize))
                        }
                    case 1:
                        // Center alignment — symbol sits too high
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: fontSize))
                                .foregroundStyle(Color.animCoral)
                            Text("Misaligned text")
                                .font(.system(size: fontSize))
                        }
                    default:
                        // Label — perfect optical alignment built in
                        Label {
                            Text("Label alignment")
                                .font(.system(size: fontSize))
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: fontSize))
                                .foregroundStyle(Color.sfGreen)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Font size slider
                HStack(spacing: 10) {
                    Text("Size")
                        .font(.system(size: 12)).foregroundStyle(.secondary).frame(width: 32)
                    Slider(value: $fontSize, in: 12...36, step: 1).tint(.sfGreen)
                    Text("\(Int(fontSize))pt")
                        .font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary).frame(width: 32)
                }

                // Tips per demo
                let tips = [
                    "HStack(alignment: .center) gives correct optical alignment for symbols alongside text",
                    "HStack(alignment: .top) misaligns, as the symbol baseline doesn't match text baseline",
                    "Label automatically handles icon-text alignment. Prefer it over manual HStack when possible"
                ]
                Text(tips[selectedDemo])
                    .font(.system(size: 12)).foregroundStyle(.secondary)
                    .animation(.easeInOut(duration: 0.2), value: selectedDemo)
            }
        }
    }
}

struct AlignmentExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Aligning symbols with text")
            Text("SF Symbols are designed to align optically with text. But the alignment axis matters, the center of a symbol sits slightly above the text baseline. SwiftUI provides tools to handle this correctly.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "HStack(alignment: .center) — correct for most symbol+text combinations. Centers the symbol on the text cap-height.", color: .sfGreen)
                StepRow(number: 2, text: "Label — the best tool for icon+text. Handles alignment, spacing, and adapts automatically to Dynamic Type.", color: .sfGreen)
                StepRow(number: 3, text: ".baselineOffset() — fine-tune vertical position if a specific symbol needs adjusting.", color: .sfGreen)
                StepRow(number: 4, text: "Never use .top or .bottom alignment for symbols alongside text — they will visually misalign.", color: .sfGreen)
            }

            CalloutBox(style: .success, title: "Use Label whenever possible", contentBody: "Label(title, systemImage:) handles all alignment automatically and adapts to Dynamic Type size changes. It also supports accessibilityLabel for free.")

            CalloutBox(style: .warning, title: "Symbol size affects alignment", contentBody: "If your symbol is a different size than the text (e.g. a large icon next to small text), optical alignment requires manual adjustment with .alignmentGuide or .offset.")

            CodeBlock(code: """
// Best — Label handles everything
Label("Downloads", systemImage: "arrow.down.circle.fill")
    .font(.body)

// Good — center alignment in HStack
HStack(alignment: .center, spacing: 6) {
    Image(systemName: "star.fill")
    Text("Rating")
}
.font(.system(size: 17))

// Fine-tune with baselineOffset
Image(systemName: "arrow.up")
    .baselineOffset(-2)  // nudge down 2pt

// Dynamic Type safe — let Label adapt
Label {
    Text("File size")
        .font(.caption)
} icon: {
    Image(systemName: "doc.fill")
        .foregroundStyle(.secondary)
}
""")
        }
    }
}
