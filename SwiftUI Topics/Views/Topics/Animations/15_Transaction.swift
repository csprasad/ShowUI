//
//
//  15_Transaction.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `22/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 15: Transaction
struct TransactionVisual: View {
    @State private var isExpanded = false
    @State private var selectedDemo = 0
    @State private var disableAnim = false
    @State private var log: [String] = []

    let demos = ["Disable animation", "Override mid-flight", "withTransaction"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Transaction", systemImage: "bolt.shield.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.animBlue)

                // Demo selector
                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button(demos[i]) {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; isExpanded = false; log = [] }
                        }
                        .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                        .foregroundStyle(selectedDemo == i ? Color.animBlue : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(selectedDemo == i ? Color(hex: "#E6F1FB") : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Preview
                ZStack {
                    Color(.secondarySystemBackground)
                    demoView
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Controls
                switch selectedDemo {
                case 0:
                    VStack(spacing: 8) {
                        Toggle("Disable animation", isOn: $disableAnim)
                            .font(.system(size: 13)).tint(Color.animBlue)
                        Button("Toggle size") {
                            if disableAnim {
                                var t = Transaction()
                                t.disablesAnimations = true
                                withTransaction(t) { isExpanded.toggle() }
                                log.append("→ Snapped instantly (animations disabled)")
                            } else {
                                withAnimation(.spring(duration: 0.5, bounce: 0.3)) { isExpanded.toggle() }
                                log.append("→ Animated with spring")
                            }
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color.animBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())
                    }
                case 1:
                    VStack(spacing: 8) {
                        Button("Animate (slow)") {
                            withAnimation(.linear(duration: 3)) { isExpanded.toggle() }
                            log.append("→ Started 3s linear animation")
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 9)
                        .background(Color.animBlue).clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())

                        Button("Override with spring") {
                            withAnimation(.spring(duration: 0.4, bounce: 0.5)) { isExpanded.toggle() }
                            log.append("→ Overrode with spring from current position")
                        }
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.animBlue)
                        .frame(maxWidth: .infinity).padding(.vertical, 9)
                        .background(Color(hex: "#E6F1FB")).clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(PressableButtonStyle())
                    }
                default:
                    Button("withTransaction") {
                        var t = Transaction(animation: .bouncy(duration: 0.6))
                        t.disablesAnimations = false
                        withTransaction(t) { isExpanded.toggle() }
                        log.append("→ Custom transaction: bouncy 0.6s")
                    }
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 9)
                    .background(Color.animBlue).clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonStyle(PressableButtonStyle())
                }

                // Log
                if !log.isEmpty {
                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(log.suffix(3), id: \.self) { line in
                            Text(line).font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.opacity)
                }
            }
        }
    }

    @ViewBuilder
    private var demoView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(LinearGradient(colors: [Color.animBlue, Color(hex: "#042C53")],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: isExpanded ? 180 : 70, height: isExpanded ? 70 : 70)
            .animation(selectedDemo == 0 ? nil : .spring(duration: 0.5, bounce: 0.3), value: isExpanded)
    }
}

struct TransactionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Transaction")
            Text("A Transaction carries animation context through the view hierarchy. withAnimation is actually shorthand for withTransaction with an animation attached. Accessing Transaction directly gives you finer control, and is useful for custom animations. You can also use it to temporarily disabling animations, overriding them, or inspecting what animation is active.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "t.disablesAnimations = true — snap a state change without any animation.", color: .animBlue)
                StepRow(number: 2, text: "withTransaction(t) — apply a custom transaction to a state change block.", color: .animBlue)
                StepRow(number: 3, text: "SwiftUI naturally handles animation interruption — a new withAnimation mid-flight continues from the current position.", color: .animBlue)
                StepRow(number: 4, text: "@Environment(\\.transaction) — read the current transaction inside a view if you need to inspect or modify it.", color: .animBlue)
            }

            CalloutBox(style: .info, title: "When to use Transaction directly", contentBody: "Mostly you won't. withAnimation covers 95% of cases. Use Transaction when you need to conditionally disable animations, or when you need to pass animation context across a boundary that withAnimation doesn't reach.")

            CodeBlock(code: """
// Disable animation for one state change
var t = Transaction()
t.disablesAnimations = true
withTransaction(t) { isExpanded = true }  // snaps instantly

// Custom transaction
var t = Transaction(animation: .bouncy(duration: 0.6))
withTransaction(t) { value.toggle() }

// Read transaction in a view modifier
struct ConditionalAnimation: ViewModifier {
    @Environment(\\.transaction) var transaction

    func body(content: Content) -> some View {
        content
            .animation(
                transaction.disablesAnimations ? nil : .spring(),
                value: someState
            )
    }
}
""")
        }
    }
}
