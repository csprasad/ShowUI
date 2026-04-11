//
//
//  8_AnimationPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `11/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI


#Preview {
    AnimPatternsVisual()
}

// MARK: - LESSON 8: Animation Patterns
struct AnimPatternsVisual: View {
    @State private var triggerStagger = false
    @State private var triggerSequence = false
    @State private var step            = 0
    @State private var repeatTrigger   = 0
    @State private var selectedDemo    = 0
    let demos = ["Stagger", "Sequence", "Repeat & loop"]
    let items = Array(0..<6)

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Animation patterns", systemImage: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.anAmber)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i; triggerStagger = false; triggerSequence = false; step = 0 }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 12, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.anAmber : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.anAmberLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                ZStack {
                    Color(.secondarySystemBackground)

                    switch selectedDemo {
                    case 0:
                        // Stagger - each item delayed
                        HStack(spacing: 10) {
                            ForEach(items, id: \.self) { i in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(gridCellColors[i % gridCellColors.count])
                                    .frame(width: 36, height: 36)
                                    .scaleEffect(triggerStagger ? 1 : 0.01)
                                    .opacity(triggerStagger ? 1 : 0)
                                    .animation(
                                        .spring(duration: 0.4, bounce: 0.3)
                                        .delay(Double(i) * 0.08),
                                        value: triggerStagger
                                    )
                            }
                        }

                    case 1:
                        // Manual sequence - each step triggers the next
                        HStack(spacing: 10) {
                            ForEach(items, id: \.self) { i in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(i < step ? gridCellColors[i % gridCellColors.count] : Color(.systemFill))
                                    .frame(width: 36, height: 36)
                                    .scaleEffect(i == step - 1 ? 1 : 0.9)
                                    .animation(.spring(bounce: 0.4), value: step)
                            }
                        }

                    default:
                        // Repeat and loop patterns
                        HStack(spacing: 20) {
                            // repeatForever
                            VStack(spacing: 6) {
                                Circle().fill(Color.anAmber).frame(width: 30, height: 30)
                                    .scaleEffect(1.0)
                                    .modifier(PulsingModifier())
                                Text("repeatForever").font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary)
                            }

                            // repeatCount
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 8).fill(Color(hex: "#7C3AED")).frame(width: 30, height: 30)
                                    .rotationEffect(.degrees(Double(repeatTrigger) * 360))
                                    .animation(.linear(duration: 0.5).repeatCount(3), value: repeatTrigger)
                                Text("repeatCount(3)").font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary)
                            }

                            // autoreverses
                            VStack(spacing: 6) {
                                Circle().fill(Color(hex: "#0F766E")).frame(width: 10, height: 30)
                                    .modifier(BouncingModifier())
                                Text("autoReverses").font(.system(size: 8, design: .monospaced)).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity).frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Controls
                switch selectedDemo {
                case 0:
                    HStack(spacing: 8) {
                        Button("Stagger in") {
                            withAnimation { triggerStagger = true }
                        }
                        .controlButton(color: .formGreen)
                        Button("Reset") {
                            withAnimation { triggerStagger = false }
                        }
                        .controlButton(color: .animCoral)
                    }

                case 1:
                    HStack(spacing: 8) {
                        Button("Next step") {
                            if step < items.count {
                                withAnimation(.spring(bounce: 0.4)) { step += 1 }
                            }
                        }
                        .controlButton(color: .formGreen)
                        .disabled(step >= items.count)

                        Button("Reset") {
                            withAnimation { step = 0 }
                        }
                        .controlButton(color: .animCoral)
                    }

                default:
                    Button("Trigger repeat") {
                        repeatTrigger += 1
                    }
                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(Color.anAmber).clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonStyle(PressableButtonStyle())
                }

                // Tips
                VStack(spacing: 6) {
                    let tips = [
                        "Stagger: .animation(curve.delay(Double(i) * 0.08), value:) - per-item delay.",
                        "Sequence: after(deadline:) DispatchQueue chain or DispatchQueue.main.asyncAfter.",
                        "repeatForever(autoreverses:) - loops. Use with .linear for continuous spin.",
                    ]
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill").font(.system(size: 11)).foregroundStyle(Color.anAmber)
                        Text(tips[selectedDemo]).font(.system(size: 11)).foregroundStyle(.secondary)
                    }
                    .padding(8).background(Color.anAmberLight).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

// Loop animation modifiers
struct PulsingModifier: ViewModifier {
    @State private var pulsing = false
    func body(content: Content) -> some View {
        content.scaleEffect(pulsing ? 1.35 : 1)
            .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: pulsing)
            .onAppear { pulsing = true }
    }
}

struct BouncingModifier: ViewModifier {
    @State private var bouncing = false
    func body(content: Content) -> some View {
        content.offset(y: bouncing ? -20 : 20)
            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: bouncing)
            .onAppear { bouncing = true }
    }
}

private extension View {
    func controlButton(color: Color) -> some View {
        self
            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(color).clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonStyle(PressableButtonStyle())
    }
}

struct AnimPatternsExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Animation patterns")
            Text("Beyond single-view animations, advanced patterns - stagger, sequencing, repeat loops - make interfaces feel alive. These patterns compose on top of SwiftUI's core animation system.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Stagger: .animation(curve.delay(Double(i) * 0.08), value:) - each item starts slightly later.", color: .anAmber)
                StepRow(number: 2, text: "Sequence: DispatchQueue.main.asyncAfter(deadline: .now() + duration) { state = next }.", color: .anAmber)
                StepRow(number: 3, text: ".repeatForever(autoreverses: true) - loops back and forth. autoreverses: false - resets instantly.", color: .anAmber)
                StepRow(number: 4, text: ".repeatCount(n) - plays exactly n times. Good for attention-grabbing effects.", color: .anAmber)
                StepRow(number: 5, text: ".onAppear animation: set initial value, then set final value in .onAppear to trigger entry animation.", color: .anAmber)
                StepRow(number: 6, text: "Performance: avoid animating layout-affecting properties on many views - prefer opacity, scale, offset.", color: .anAmber)
            }

            CalloutBox(style: .success, title: "Stagger is just delay per item", contentBody: "There's no special stagger API - just .delay() scaled by the item index. The key is passing the index through ForEach and applying .animation(curve.delay(Double(i) * gap), value: trigger) independently to each view.")

            CalloutBox(style: .info, title: "Performance: scale/opacity over layout", contentBody: "Animating .offset(), .scaleEffect(), .opacity(), and .rotationEffect() is cheap - rendered by Core Animation without layout passes. Animating .frame(), .padding(), .font(size:) triggers layout passes per frame - expensive for many views.")

            CodeBlock(code: """
// Stagger - delay per item
ForEach(items.indices, id: \\.self) { i in
    ItemView(item: items[i])
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(
            .spring(duration: 0.4).delay(Double(i) * 0.06),
            value: appeared
        )
}
.onAppear { appeared = true }

// Sequenced states
func runSequence() {
    withAnimation(.spring()) { step = 1 }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        withAnimation(.spring()) { step = 2 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring()) { step = 3 }
        }
    }
}

// Continuous loop
Circle()
    .scaleEffect(pulsing ? 1.3 : 1)
    .animation(
        .easeInOut(duration: 0.8)
        .repeatForever(autoreverses: true),
        value: pulsing
    )
    .onAppear { pulsing = true }
""")
        }
    }
}

