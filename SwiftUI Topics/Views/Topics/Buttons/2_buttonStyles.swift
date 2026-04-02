//
//
//  2_buttonStyles.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Button Styles

struct ButtonStylesVisual: View {
    @State private var selectedStyle = 0
    @State private var tapped = false

    struct StyleOption {
        let name: String
        let code: String
        let description: String
    }

    let styles: [StyleOption] = [
        StyleOption(name: "automatic",          code: ".buttonStyle(.automatic)",          description: "Context-aware default - varies by container"),
        StyleOption(name: "plain",              code: ".buttonStyle(.plain)",              description: "No decoration - just the label content"),
        StyleOption(name: "borderless",         code: ".buttonStyle(.borderless)",         description: "Tinted text, no border. Good for inline actions"),
        StyleOption(name: "bordered",           code: ".buttonStyle(.bordered)",           description: "Rounded background tinted by role/tint color"),
        StyleOption(name: "borderedProminent",  code: ".buttonStyle(.borderedProminent)",  description: "Filled background - primary action, most prominent"),
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Button styles", systemImage: "paintbrush.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)

                // Show all 5 styles at once for comparison
                VStack(spacing: 10) {
                    ForEach(styles.indices, id: \.self) { i in
                        HStack(spacing: 12) {
                            // Style label
                            Text(".\(styles[i].name)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .frame(width: 100, alignment: .leading)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)

                            // Live button with that style
                            styleButton(i)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(selectedStyle == i ? Color.btnPurpleLight : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture { withAnimation(.spring(response: 0.3)) { selectedStyle = i } }
                    }
                }

                // Selected style details
                VStack(alignment: .leading, spacing: 4) {
                    Text(styles[selectedStyle].description)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .animation(.easeInOut(duration: 0.15), value: selectedStyle)

                // Tint color effect
                VStack(alignment: .leading, spacing: 8) {
                    Text("With .tint()")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        ForEach([Color.btnPurple, Color.animTeal, Color.animCoral, Color.animAmber], id: \.self) { color in
                            Button("Action") { }
                                .buttonStyle(.borderedProminent)
                                .tint(color)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func styleButton(_ index: Int) -> some View {
        switch index {
        case 0:
            Button("Button") { }
                .buttonStyle(.automatic)
                .tint(.btnPurple)
        case 1:
            Button("Button") { }
                .buttonStyle(.plain)
                .foregroundStyle(Color.btnPurple)
        case 2:
            Button("Button") { }
                .buttonStyle(.borderless)
                .tint(.btnPurple)
        case 3:
            Button("Button") { }
                .buttonStyle(.bordered)
                .tint(.btnPurple)
        default:
            Button("Button") { }
                .buttonStyle(.borderedProminent)
                .tint(.btnPurple)
        }
    }
}

struct ButtonStylesExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Built-in button styles")
            Text("SwiftUI provides five built-in ButtonStyle values that adapt to platform conventions, Dynamic Type, and accessibility settings. They're the right starting point, but you can only build a custom style when none of these fit.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".automatic - default. Context-dependent: minimal in Lists, platform standard elsewhere.", color: .btnPurple)
                StepRow(number: 2, text: ".plain - no visual decoration. The label renders exactly as-is. Use when you want full manual control.", color: .btnPurple)
                StepRow(number: 3, text: ".borderless - tints the label with the tint color but adds no border or background. Good for inline and toolbar buttons.", color: .btnPurple)
                StepRow(number: 4, text: ".bordered - adds a rounded background. Standard choice for secondary actions.", color: .btnPurple)
                StepRow(number: 5, text: ".borderedProminent - filled background. Use for the primary call-to-action on a screen.", color: .btnPurple)
            }

            CalloutBox(style: .success, title: ".tint() controls their color", contentBody: "All built-in styles respond to .tint(). Apply it to a button or its container and every bordered/borderless style in that scope inherits it. The role overrides tint for .destructive.")

            CalloutBox(style: .info, title: "controlSize adjusts scale", contentBody: ".controlSize(.large / .regular / .small / .mini) adjusts the padding and font size of bordered buttons, making them useful for building toolbar buttons, form buttons, or compact UI without manual sizing.")

            CodeBlock(code: """
// Primary action
Button("Save") { save() }
    .buttonStyle(.borderedProminent)
    .tint(.blue)

// Secondary action
Button("Cancel") { cancel() }
    .buttonStyle(.bordered)

// Inline action (e.g. inside a List row)
Button("Edit") { edit() }
    .buttonStyle(.borderless)

// Control size
Button("Large Action") { }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)

// Apply tint to a group
HStack {
    Button("Yes") { }
    Button("No") { }
}
.buttonStyle(.bordered)
.tint(.green)
""")
        }
    }
}
