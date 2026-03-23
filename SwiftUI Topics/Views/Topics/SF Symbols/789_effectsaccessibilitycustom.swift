//
//
//  789_effectsaccessibilitycustom.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `23/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Symbol Effects (Reference)

struct EffectsReferenceVisual: View {
    @State private var trigger = 0
    @State private var selectedEffect = 0

    struct EffectRef {
        let name: String
        let icon: String
        let minOS: String
    }

    let effects: [EffectRef] = [
        EffectRef(name: ".bounce",       icon: "bell.fill",           minOS: "17"),
        EffectRef(name: ".pulse",        icon: "heart.fill",          minOS: "17"),
        EffectRef(name: ".variableColor",icon: "speaker.wave.3.fill", minOS: "17"),
        EffectRef(name: ".appear",       icon: "star.fill",           minOS: "17"),
        EffectRef(name: ".wiggle",       icon: "trash.fill",          minOS: "18"),
        EffectRef(name: ".breathe",      icon: "lungs.fill",          minOS: "18"),
        EffectRef(name: ".rotate",       icon: "arrow.circlepath",    minOS: "18"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Symbol effects", systemImage: "sparkles")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.sfGreen)
                    Spacer()
                    NavigationLink {
                        // Points toward Animations topic lesson 7
                        Text("See Animations → Lesson 7 for full coverage")
                            .font(.system(size: 15)).foregroundStyle(.secondary).padding()
                    } label: {
                        Text("Full lesson →")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.sfGreen)
                    }
                }

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    effectPreview
                }
                .frame(maxWidth: .infinity).frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Button {
                    trigger += 1
                } label: {
                    Text("Trigger")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.sfGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())

                // Effect chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(effects.indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.3)) { selectedEffect = i; trigger = 0 }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(effects[i].name)
                                        .font(.system(size: 11, weight: selectedEffect == i ? .semibold : .regular, design: .monospaced))
                                        .foregroundStyle(selectedEffect == i ? Color.sfGreen : .secondary)
                                    if effects[i].minOS == "18" {
                                        Text("18+")
                                            .font(.system(size: 8, weight: .medium))
                                            .foregroundStyle(Color.animAmber)
                                    }
                                }
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(selectedEffect == i ? Color.sfGreenLight : Color(.systemFill))
                                .clipShape(Capsule())
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var effectPreview: some View {
        let e = effects[selectedEffect]
        switch selectedEffect {
        case 0:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.bounce, value: trigger)
        case 1:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.pulse, value: trigger)
        case 2:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.variableColor, value: trigger)
        case 3:
            Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                .symbolEffect(.appear, isActive: trigger % 2 == 1)
        case 4:
            if #available(iOS 18, *) {
                Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                    .symbolEffect(.wiggle, value: trigger)
            } else { Text("iOS 18+ required").font(.system(size: 13)).foregroundStyle(.secondary) }
        case 5:
            if #available(iOS 18, *) {
                Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                    .symbolEffect(.breathe, value: trigger)
            } else { Text("iOS 18+ required").font(.system(size: 13)).foregroundStyle(.secondary) }
        default:
            if #available(iOS 18, *) {
                Image(systemName: e.icon).font(.system(size: 52)).foregroundStyle(Color.sfGreen)
                    .symbolEffect(.rotate, value: trigger)
            } else { Text("iOS 18+ required").font(.system(size: 13)).foregroundStyle(.secondary) }
        }
    }
}

struct EffectsReferenceExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Symbol effects — quick reference")
            Text("Symbol effects are covered in depth in the Animations topic (Lesson 7). This is a quick reference for the most common effects and their availability.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".bounce, .pulse, .variableColor, .appear, .disappear — iOS 17+", color: .sfGreen)
                StepRow(number: 2, text: ".wiggle, .breathe, .rotate — iOS 18+", color: .sfGreen)
                StepRow(number: 3, text: "value: trigger — fires once when value changes.", color: .sfGreen)
                StepRow(number: 4, text: "options: .repeating, isActive: bool — loops while true.", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "See Animations → Lesson 7", contentBody: "The full interactive lesson with all effects, trigger vs loop modes, and layer-aware behaviour is in the Animations topic.")

            CodeBlock(code: """
// Trigger once — value changes fire the effect
Image(systemName: "bell.fill")
    .symbolEffect(.bounce, value: notificationCount)

// Loop — runs while isActive is true
Image(systemName: "arrow.circlepath")
    .symbolEffect(.rotate, options: .repeating, isActive: isLoading)

// iOS 18+ effects need availability check
if #available(iOS 18, *) {
    Image(systemName: "trash.fill")
        .symbolEffect(.wiggle, value: deleteCount)
}
""")
        }
    }
}

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
            Text("VoiceOver reads SF Symbol names literally — \"person fill xmark\" is meaningless to most users. Every meaningful symbol needs a human-readable label. Decorative symbols should be hidden entirely.")
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

// MARK: - LESSON 9: Custom Symbols

struct CustomSymbolVisual: View {
    @State private var selectedStep = 0

    let steps = [
        (icon: "square.and.arrow.down", title: "Design in SF Symbols app",   description: "Start from an existing symbol or draw from scratch using the SF Symbols app's canvas. Export as SVG template."),
        (icon: "pencil.and.outline",    title: "Draw in vector tool",         description: "Open the SVG template in Figma, Sketch or Illustrator. Draw your symbol using the provided guides for optical sizing."),
        (icon: "arrow.up.doc",          title: "Import into Xcode",           description: "Drag the .svg into your Xcode asset catalog. Set the Symbol tab, assign rendering layers, and set the symbol name."),
        (icon: "checkmark.circle.fill", title: "Use like any symbol",         description: "Image(systemName: \"your.custom.symbol\") — it inherits font weight, rendering modes and symbol effects automatically."),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom symbols", systemImage: "square.and.pencil")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.sfGreen)

                // Step flow
                VStack(spacing: 8) {
                    ForEach(steps.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedStep = i }
                        } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(selectedStep == i ? Color.sfGreen : Color(.systemFill))
                                        .frame(width: 32, height: 32)
                                    if selectedStep == i {
                                        Image(systemName: steps[i].icon)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.white)
                                    } else {
                                        Text("\(i + 1)")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(steps[i].title)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(selectedStep == i ? Color.sfGreen : .primary)
                                    if selectedStep == i {
                                        Text(steps[i].description)
                                            .font(.system(size: 11))
                                            .foregroundStyle(.secondary)
                                            .lineSpacing(2)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .transition(.opacity.combined(with: .move(edge: .top)))
                                    }
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(selectedStep == i ? Color.sfGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
            }
        }
    }
}

struct CustomSymbolExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Creating custom symbols")
            Text("Custom SF Symbols are SVG files imported into your Xcode asset catalog. Once imported, they behave identically to system symbols — they support all rendering modes, weights, scales and symbol effects.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Download the SF Symbols app (free from Apple). Use File → Export Template to get the SVG guide.", color: .sfGreen)
                StepRow(number: 2, text: "Draw in the template. Adhere to the optical alignment guides — they ensure your symbol looks correct at all weights.", color: .sfGreen)
                StepRow(number: 3, text: "In Xcode: Assets.xcassets → + → New Symbol Image Set. Drag in your SVG.", color: .sfGreen)
                StepRow(number: 4, text: "Use Image(systemName: \"your.symbol.name\") — the name matches the asset catalog entry.", color: .sfGreen)
                StepRow(number: 5, text: "Assign layers in the Symbol inspector in Xcode — mark which paths are primary, secondary, tertiary for palette/hierarchical modes.", color: .sfGreen)
            }

            CalloutBox(style: .info, title: "Weight variants", contentBody: "You can provide 27 weight/scale variants (9 weights × 3 scales) for pixel-perfect rendering. At minimum provide Regular-Medium. Xcode interpolates the rest — results vary in quality.")

            CalloutBox(style: .warning, title: "Name conflicts", contentBody: "Custom symbol names shadow system symbol names if they match. Use a unique prefix like \"custom.\" or your app prefix to avoid accidental conflicts across iOS versions.")

            CodeBlock(code: """
// In asset catalog: named "app.chart.line"
Image(systemName: "app.chart.line")
    .font(.system(size: 24, weight: .semibold))
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.blue)

// Custom symbols support all the same modifiers
Image(systemName: "app.chart.line")
    .symbolEffect(.bounce, value: tapCount)
    .symbolVariant(.fill)
    .imageScale(.large)
""")
        }
    }
}
