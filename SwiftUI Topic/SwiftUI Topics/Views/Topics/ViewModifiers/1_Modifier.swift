//
//
//  1_Modifier.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 1: What Is a Modifier
struct WhatIsModifierVisual: View {
    @State private var step = 0
    @State private var showChain = false

    let steps = ["No modifiers", "+ padding", "+ background", "+ cornerRadius", "+ shadow"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("What is a modifier", systemImage: "arrow.forward.circle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                // Step selector
                VStack(spacing: 5) {
                    ForEach(steps.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { step = i }
                        } label: {
                            HStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(i <= step ? Color.vmGreen : Color(.systemFill))
                                        .frame(width: 22, height: 22)
                                    Text("\(i)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(i <= step ? .white : .secondary)
                                }
                                Text(steps[i])
                                    .font(.system(size: 12, weight: i == step ? .semibold : .regular))
                                    .foregroundStyle(i == step ? Color.vmGreen : i < step ? .primary : .secondary)
                                Spacer()
                                if i < step {
                                    Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundStyle(Color.vmGreen)
                                }
                            }
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(i == step ? Color.vmGreenLight : Color(.systemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live preview
                ZStack {
                    Color(.secondarySystemBackground)
                    HStack(spacing: 20) {
                        // Preview
                        VStack(spacing: 6) {
                            Text("Preview").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                            viewAtStep(step)
                        }
                        // Code
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Code").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                            codeAtStep(step)
                        }
                        Spacer()
                    }
                    .padding(12)
                }
                .frame(maxWidth: .infinity).frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.spring(response: 0.4), value: step)
            }
        }
    }

    @ViewBuilder
    func viewAtStep(_ s: Int) -> some View {
        switch s {
        case 0: Text("Hello").font(.system(size: 14))
        case 1: Text("Hello").font(.system(size: 14)).padding(12)
        case 2: Text("Hello").font(.system(size: 14)).padding(12)
                    .background(Color.vmGreenLight)
        case 3: Text("Hello").font(.system(size: 14)).padding(12)
                    .background(Color.vmGreenLight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
        default: Text("Hello").font(.system(size: 14)).padding(12)
                    .background(Color.vmGreenLight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.vmGreen.opacity(0.25), radius: 6, y: 3)
        }
    }

    @ViewBuilder
    func codeAtStep(_ s: Int) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            codeToken("Text(\"Hello\")", color: .blue)
            if s >= 1 { codeToken("  .padding(12)", color: .vmGreen, indent: false) }
            if s >= 2 { codeToken("  .background(.vmGreenLight)", color: .vmGreen, indent: false) }
            if s >= 3 { codeToken("  .clipShape(RoundedRectangle(", color: .vmGreen, indent: false) }
            if s >= 3 { codeToken("      cornerRadius: 10))", color: .vmGreen, indent: false) }
            if s >= 4 { codeToken("  .shadow(radius: 6, y: 3)", color: .vmGreen, indent: false) }
        }
    }

    func codeToken(_ text: String, color: Color, indent: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(color)
    }
}

struct WhatIsModifierExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Modifiers - wrapping views")
            Text("Every modifier in SwiftUI takes a view, wraps it in a new view with additional behavior or appearance, and returns the result. Calling .padding() on a Text doesn't modify the Text - it creates a new view that contains the Text with padding applied.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Each modifier is a method returning a new View. The original view is wrapped inside.", color: .vmGreen)
                StepRow(number: 2, text: "Modifiers chain from top to bottom - the result of each becomes the input to the next.", color: .vmGreen)
                StepRow(number: 3, text: "ViewModifier protocol - any struct with body(content:) can become a modifier.", color: .vmGreen)
                StepRow(number: 4, text: ".modifier(MyModifier()) applies a custom ViewModifier to any view.", color: .vmGreen)
            }

            CalloutBox(style: .info, title: "Modifiers create a view tree", contentBody: "Text(\"Hi\").padding().background(.blue) creates: BackgroundView(PaddingView(Text(\"Hi\"))). SwiftUI renders this nested structure. Understanding this helps explain why modifier order matters so much.")

            CodeBlock(code: """
// Each modifier wraps the previous view
Text("Hello")
    .padding(16)           // PaddingView(Text)
    .background(.blue)     // BackgroundView(PaddingView(Text))
    .clipShape(Capsule())  // ClipView(BackgroundView(PaddingView(Text)))

// Under the hood - equivalent to:
let text = Text("Hello")
let padded = text.padding(16)
let backed = padded.background(.blue)
let clipped = backed.clipShape(Capsule())

// Using ViewModifier protocol
struct Highlighted: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

Text("Note")
    .modifier(Highlighted())
""")
        }
    }
}
