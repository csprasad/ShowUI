//
//
//  2_ExplicitVsImplicit.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 2: Explicit withAnimation vs Implicit .animation()
struct ExplicitImplicitVisual: View {
    @State private var isExpanded    = false
    @State private var position: CGFloat = 0
    @State private var tapped        = false
    @State private var selectedDemo  = 0
    let demos = ["Side by side", "Binding", "When to use"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("withAnimation vs .animation()", systemImage: "arrow.trianglehead.counterclockwise")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.anAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.anAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Side by side comparison
                    VStack(spacing: 12) {
                        HStack(spacing: 10) {
                            // Explicit
                            VStack(spacing: 6) {
                                Text("withAnimation { }").font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(Color.anAmber)
                                ZStack {
                                    Color(.secondarySystemBackground)
                                    RoundedRectangle(cornerRadius: 10).fill(Color.anAmber)
                                        .frame(width: 40, height: 40)
                                        .offset(y: isExpanded ? -20 : 20)
                                        .animation(.spring(bounce: 0.3), value: isExpanded)
                                }
                                .frame(height: 100).clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                                
                                Button("Trigger") {
                                    withAnimation(.spring(bounce: 0.3)) { isExpanded.toggle() }
                                }
                                .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.anAmber)
                                .buttonStyle(PressableButtonStyle())
                                .frame(height: 10)
                                .padding(10)
                                .background(Color.anAmberLight)
                                .cornerRadius(5)

                                Text("State change inside closure")
                                    .font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)

                            Divider()

                            // Implicit
                            VStack(spacing: 6) {
                                Text(".animation(on: value)").font(.system(size: 10, weight: .semibold, design: .monospaced)).foregroundStyle(Color.btnPurple)
                                ZStack {
                                    Color(.secondarySystemBackground)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.btnPurple)
                                        .frame(width: 40, height: 40)
                                        .offset(y: isExpanded ? -20 : 20)
                                        .animation(.bouncy, value: isExpanded)
                                }
                                .frame(height: 100).clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                                
                                Button("Trigger") { isExpanded.toggle() }
                                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.btnPurple)
                                    .buttonStyle(PressableButtonStyle())
                                    .frame(height: 10)
                                    .padding(10)
                                    .background(Color.btnPurpleLight)
                                    .cornerRadius(5)
                                Text("Modifier on view, automatically")
                                    .font(.system(size: 9)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundStyle(Color.anAmber)
                            Text("Both animate the same state. Explicit gives per-change control; implicit reacts to value changes automatically.")
                                .font(.system(size: 11)).foregroundStyle(.secondary)
                        }
                        .padding(8).background(Color.anAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                case 1:
                    // Binding animation
                    VStack(spacing: 12) {
                        Text("Binding animation - .animation() on the binding itself")
                            .font(.system(size: 11, weight: .semibold)).foregroundStyle(.secondary)

                        Toggle("Toggle with animated binding", isOn: $isExpanded.animation(.spring(bounce: 0.4)))
                            .tint(.anAmber)
                            .padding(.horizontal, 12).padding(.vertical, 10)
                            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

                        ZStack {
                            Color(.secondarySystemBackground)
                            if isExpanded {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(LinearGradient(colors: [Color.anAmber, Color(hex: "#F59E0B")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 100, height: 60)
                                    .overlay(Text("Visible").font(.system(size: 12, weight: .bold)).foregroundStyle(.white))
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .frame(maxWidth: .infinity).frame(height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .animation(.spring(bounce: 0.4), value: isExpanded)

                        codeChip("Toggle(\"…\", isOn: $bool.animation(.spring(bounce: 0.4)))")
                        Text("The animation is baked into the binding - any source of change animates it.")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                    }

                default:
                    // Decision guide
                    VStack(alignment: .leading, spacing: 8) {
                        decisionRow(
                            emoji: "✓",
                            title: "Use withAnimation { } when:",
                            points: ["Button taps and gesture completions", "Multiple state changes that should animate together", "You want different animations per event"]
                        )
                        decisionRow(
                            emoji: "✓",
                            title: "Use .animation(curve, value:) when:",
                            points: ["View responds to data changes (not user action)", "Derived state that should always animate", "Content renders with computed values"]
                        )
                        decisionRow(
                            emoji: "!",
                            title: "Avoid .animation() without value: (deprecated)",
                            points: ["Animates ALL changes on the view - causes unexpected animations", "Hard to debug which change triggered it", "Use .animation(curve, value: specificBinding) instead"]
                        )
                    }
                }
            }
        }
    }

    func codeChip(_ code: String) -> some View {
        Text(code)
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(Color.anAmber)
            .padding(8).background(Color.anAmberLight).clipShape(RoundedRectangle(cornerRadius: 7))
    }

    func decisionRow(emoji: String, title: String, points: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(emoji) \(title)").font(.system(size: 12, weight: .semibold)).foregroundStyle(.primary)
            VStack(alignment: .leading, spacing: 3) {
                ForEach(points, id: \.self) { pt in
                    HStack(alignment: .center, spacing: 4) {
                        Text("·").foregroundStyle(.secondary)
                        Text(pt).font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(10).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ExplicitImplicitExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "withAnimation vs .animation()")
            Text("SwiftUI has two animation mechanisms. withAnimation { } wraps a state change so every animated property in that change animates. .animation(curve, value:) on a view watches a specific value and animates whenever it changes.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "withAnimation(.spring()) { state = newValue } - explicit. Animates all changes inside the closure.", color: .anAmber)
                StepRow(number: 2, text: ".animation(.spring(), value: someBinding) - implicit. Animates when value changes from any source.", color: .anAmber)
                StepRow(number: 3, text: "$binding.animation(.spring()) - binding-level. The animation travels with the binding itself.", color: .anAmber)
                StepRow(number: 4, text: "Avoid legacy .animation() with no value: - animates ALL changes on the view, causing hard-to-debug side effects.", color: .anAmber)
                StepRow(number: 5, text: "Multiple animations: each view can have different .animation() curves for different values.", color: .anAmber)
            }

            CalloutBox(style: .info, title: "Prefer value: on .animation()", contentBody: ".animation(.spring()) without value: is deprecated and animates every property change. Always specify the value: .animation(.spring(), value: isExpanded) - only animates when isExpanded changes.")

            CodeBlock(code: """
// Explicit - wraps state change
Button("Toggle") {
    withAnimation(.spring(bounce: 0.3)) {
        isExpanded.toggle()
        color = isExpanded ? .blue : .red
        // Both changes animate together
    }
}

// Implicit - watches a value
Rectangle()
    .fill(isExpanded ? Color.blue : .gray)
    .frame(height: isExpanded ? 200 : 100)
    .animation(.spring(), value: isExpanded)

// Binding animation
Toggle("Option", isOn: $isOn.animation(.spring()))

// Multiple curves per property
view
    .opacity(isVisible ? 1 : 0)
    .animation(.easeOut(duration: 0.3), value: isVisible)
    .offset(y: isVisible ? 0 : 20)
    .animation(.spring(bounce: 0.2), value: isVisible)
""")
        }
    }
}

