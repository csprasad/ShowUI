//
//
//  8_accessibility.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 8: Accessibility
struct AccessibilityVisual: View {
    @State private var selectedDemo = 0
    let demos = ["No label", "With label", "Decorative"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Accessibility", systemImage: "accessibility.fill")
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

                // Visual preview
                ZStack {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 12) {
                        switch selectedDemo {
                        case 0:
                            // Problem — no label, VoiceOver reads symbol name
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill.xmark")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.animCoral)
                                VStack(alignment: .leading) {
                                    Text("VoiceOver reads:")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                    Text("\"person fill xmark\"")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(Color.animCoral)
                                }
                            }
                        case 1:
                            // Good — accessibilityLabel set
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill.xmark")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.sfGreen)
                                    .accessibilityLabel("Remove user")
                                VStack(alignment: .leading) {
                                    Text("VoiceOver reads:")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                    Text("\"Remove user\"")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(Color.sfGreen)
                                }
                            }
                        default:
                            // Decorative — hidden from VoiceOver
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.sfGreen)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading) {
                                    Text("VoiceOver reads:")
                                        .font(.system(size: 11)).foregroundStyle(.secondary)
                                    Text("(nothing — hidden)")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Code
                let codes = [
                    "Image(systemName: \"person.fill.xmark\")\n// No label — VoiceOver reads the symbol name",
                    "Image(systemName: \"person.fill.xmark\")\n    .accessibilityLabel(\"Remove user\")",
                    "Image(systemName: \"sparkles\")\n    .accessibilityHidden(true)"
                ]
                CodeBlock(code: codes[selectedDemo])
            }
        }
    }
}

struct AccessibilityExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Making symbols accessible")
            Text("VoiceOver reads SF Symbol names literally, so \"person fill xmark\" is meaningless to most users. Every meaningful symbol needs a human-readable label. Decorative symbols should be hidden entirely.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".accessibilityLabel(\"Remove user\") — give a clear, action-oriented description of what the symbol means in context.", color: .sfGreen)
                StepRow(number: 2, text: ".accessibilityHidden(true) — hide purely decorative symbols. VoiceOver skips them entirely.", color: .sfGreen)
                StepRow(number: 3, text: "Label automatically uses the title text as the accessibility label — another reason to prefer it over Image alone.", color: .sfGreen)
                StepRow(number: 4, text: "Button { } label: { Image(...) } — the button needs an accessibilityLabel if the image-only label isn't descriptive.", color: .sfGreen)
            }

            CalloutBox(style: .danger, title: "Image-only buttons are a common mistake", contentBody: "A Button containing only an Image(systemName:) with no accessibilityLabel will read the symbol file name to VoiceOver users. Always add .accessibilityLabel to image-only buttons.")

            CalloutBox(style: .success, title: "Context matters for labels", contentBody: "\"Star\" is a bad label. \"Add to favorites\" is good. The label should describe the action or meaning in the current context, not just name the icon.")

            CodeBlock(code: """
// Standalone symbol — describe its meaning
Image(systemName: "heart.fill")
    .accessibilityLabel("Liked")

// Decorative — hidden from VoiceOver
Image(systemName: "sparkles")
    .accessibilityHidden(true)

// Image-only button — needs label
Button {
    deleteItem()
} label: {
    Image(systemName: "trash.fill")
        .accessibilityLabel("Delete item")
}

// Label uses title automatically ✓
Label("Delete", systemImage: "trash.fill")
// VoiceOver: "Delete, button"
""")
        }
    }
}
