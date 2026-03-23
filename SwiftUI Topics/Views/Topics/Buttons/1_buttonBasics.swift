//
//
//  1_buttonBasics.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `24/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: Button Basics
struct ButtonBasicsVisual: View {
    @State private var tapCount = 0
    @State private var lastRole = "none"
    @State private var showDestructive = false
    @State private var showCancel = false

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Button basics", systemImage: "hand.tap.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.btnPurple)

                // Live tap counter
                ZStack {
                    Color(.secondarySystemBackground)
                    VStack(spacing: 8) {
                        Text("\(tapCount)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.btnPurple)
                            .contentTransition(.numericText())
                            .animation(.spring(duration: 0.3), value: tapCount)
                        Text("taps")
                            .font(.system(size: 13)).foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Normal button
                Button {
                    withAnimation { tapCount += 1 }
                    lastRole = "default"
                } label: {
                    Text("Default button")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.btnPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PressableButtonStyle())

                // Role buttons
                HStack(spacing: 10) {
                    Button(role: .destructive) {
                        lastRole = "destructive"
                        tapCount = 0
                    } label: {
                        Text("Destructive")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(.systemRed).opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())

                    Button(role: .cancel) {
                        lastRole = "cancel"
                        tapCount = 0
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                }

                // Role indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(roleColor(lastRole))
                        .frame(width: 8, height: 8)
                    Text("Last role: .\(lastRole)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .animation(.easeInOut(duration: 0.2), value: lastRole)
            }
        }
    }

    func roleColor(_ role: String) -> Color {
        switch role {
        case "destructive": return .red
        case "cancel": return .secondary
        default: return .btnPurple
        }
    }
}

struct ButtonBasicsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Button fundamentals")
            Text("A Button in SwiftUI has three parts an action closure, a label view, and an optional role. The role tells SwiftUI and accessibility tools the semantic intent of the button, and it affects tinting and VoiceOver behaviour automatically.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "The action closure fires when the button is tapped. Any state changes inside it update the UI.", color: .btnPurple)
                StepRow(number: 2, text: ".destructive — tints the button red, signals irreversible action. Used in alerts and confirmation dialogs.", color: .btnPurple)
                StepRow(number: 3, text: ".cancel — signals a dismissal. Used alongside .destructive to give users an escape route.", color: .btnPurple)
                StepRow(number: 4, text: "The label can be any View — Text, Image, Label, HStack, or a fully custom view.", color: .btnPurple)
            }

            CalloutBox(style: .info, title: "Role affects style automatically", contentBody: "Button(role: .destructive) with a .bordered style automatically renders in red. You don't need to manually set the color, and the role propagates through the style system.")

            CalloutBox(style: .success, title: "Always use a label closure for complex labels", contentBody: "Button(\"Title\") { } is fine for plain text. For anything with an image, padding, or custom styling, use Button { action } label: { } so styling is inside the label and hit testing works correctly.")

            CodeBlock(code: """
// Simple text button
Button("Tap me") {
    count += 1
}

// Label closure — preferred for styled buttons
Button {
    saveDocument()
} label: {
    Label("Save", systemImage: "square.and.arrow.down")
}

// Destructive role — turns red automatically
Button(role: .destructive) {
    deleteItem()
} label: {
    Text("Delete")
}

// Cancel role
Button(role: .cancel) {
    dismiss()
} label: {
    Text("Cancel")
}
""")
        }
    }
}
