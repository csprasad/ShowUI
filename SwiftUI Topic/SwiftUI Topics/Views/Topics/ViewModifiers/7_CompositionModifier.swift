//
//
//  7_CompositionModifier.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 7: Modifier Composition
// Composited modifier: card + press feedback + accessibility
struct InteractiveCardModifier: ViewModifier {
    var color: Color
    var isSelected: Bool

    @GestureState private var isPressed = false

    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? color : Color(.systemBackground))
                    .shadow(color: isSelected ? color.opacity(0.25) : .black.opacity(0.06),
                            radius: isSelected ? 10 : 4,
                            y: isSelected ? 4 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? color : Color(.systemFill), lineWidth: isSelected ? 2 : 0.5)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isPressed)
            .animation(.spring(response: 0.35), value: isSelected)
            .gesture(DragGesture(minimumDistance: 0).updating($isPressed) { _, s, _ in s = true })
    }
}

// Animatable modifier - number counter
struct ScaleAndFadeModifier: AnimatableModifier {
    var scale: CGFloat
    var opacity: Double

    var animatableData: AnimatablePair<CGFloat, Double> {
        get { AnimatablePair(scale, opacity) }
        set { scale = newValue.first; opacity = newValue.second }
    }

    func body(content: Content) -> some View {
        content.scaleEffect(scale).opacity(opacity)
    }
}

struct ModifierCompositionVisual: View {
    @State private var selected = Set<Int>()
    @State private var triggerAnim = false
    @State private var selectedDemo = 0

    let demos = ["Composed card", "AnimatableModifier", "Modifier stack"]
    let items = ["Swift", "SwiftUI", "Combine", "CoreData"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Modifier composition", systemImage: "square.stack.3d.up.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.vmGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.vmGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Composed card modifier
                    VStack(spacing: 10) {
                        Text("Tap to select - InteractiveCardModifier combines background + shadow + overlay + press + animation")
                            .font(.system(size: 10)).foregroundStyle(.secondary)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                            ForEach(items.indices, id: \.self) { i in
                                Button {
                                    withAnimation(.spring(response: 0.35)) {
                                        if selected.contains(i) { selected.remove(i) }
                                        else { selected.insert(i) }
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: selected.contains(i) ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(selected.contains(i) ? Color.vmGreen : .secondary)
                                        Text(items[i])
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(selected.contains(i) ? Color.vmGreen : .primary)
                                    }
                                }
                                .modifier(InteractiveCardModifier(color: .vmGreen, isSelected: selected.contains(i)))
                            }
                        }
                    }

                case 1:
                    // AnimatableModifier
                    VStack(spacing: 14) {
                        Text("AnimatableModifier interpolates multiple values simultaneously")
                            .font(.system(size: 10)).foregroundStyle(.secondary)

                        HStack(spacing: 20) {
                            ForEach(["Hello", "World", "Swift"], id: \.self) { word in
                                Text(word)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(Color.vmGreen)
                                    .modifier(ScaleAndFadeModifier(
                                        scale: triggerAnim ? 1.0 : 0.5,
                                        opacity: triggerAnim ? 1.0 : 0.0
                                    ))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(triggerAnim ? 0 : 0), value: triggerAnim)
                            }
                        }
                        .frame(height: 50)

                        Button {
                            triggerAnim = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    triggerAnim = true
                                }
                            }
                        } label: {
                            Text("Trigger ScaleAndFade")
                                .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(Color.vmGreen).clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }

                default:
                    // Modifier stack diagram
                    VStack(spacing: 6) {
                        Text("Modifiers compose into a view tree").font(.system(size: 10, weight: .semibold)).foregroundStyle(.secondary)
                        let layers: [(String, Color)] = [
                            ("ShadowView", .animAmber),
                            ("OverlayView", .navBlue),
                            ("ClipView", .vmGreen),
                            ("BackgroundView", .vmGreen.opacity(0.6)),
                            ("PaddingView", .vmGreen.opacity(0.4)),
                            ("Text(\"Hello\")", Color(hex: "#4ADE80")),
                        ]
                        ForEach(layers.indices, id: \.self) { i in
                            HStack(spacing: 6) {
                                Spacer().frame(width: CGFloat(i) * 12)
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(layers[i].1.opacity(0.15))
                                    .frame(height: 28)
                                    .overlay(
                                        HStack {
                                            Text(i == layers.count - 1 ? "◉" : "╔").font(.system(size: 8)).foregroundStyle(layers[i].1)
                                            Text(layers[i].0).font(.system(size: 9, design: .monospaced)).foregroundStyle(layers[i].1)
                                            Spacer()
                                        }.padding(.horizontal, 6)
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ModifierCompositionExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Modifier composition")
            Text("Complex UI components are built by composing multiple modifiers inside a single ViewModifier. This creates reusable, self-contained components - one modifier applies background, shadow, border, press feedback, and animation together.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Compose background + overlay + shadow + gesture in one ViewModifier for a complete interactive card.", color: .vmGreen)
                StepRow(number: 2, text: "AnimatableModifier lets a custom modifier participate in SwiftUI animations via animatableData.", color: .vmGreen)
                StepRow(number: 3, text: "animatableData uses AnimatablePair to interpolate multiple values simultaneously.", color: .vmGreen)
                StepRow(number: 4, text: "@GestureState inside ViewModifier - the modifier manages its own interaction state.", color: .vmGreen)
            }

            CalloutBox(style: .info, title: "AnimatableModifier interpolates modifier values", contentBody: "When you animate a view using a custom modifier, SwiftUI calls body(content:) many times per second with interpolated values. AnimatableModifier tells SwiftUI how to interpolate your custom values.")

            CodeBlock(code: """
// Compose multiple modifiers in one
struct SelectableCard: ViewModifier {
    var isSelected: Bool
    @GestureState private var isPressed = false

    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : .white)
                    .shadow(color: isSelected ? .blue.opacity(0.2) : .black.opacity(0.05),
                            radius: isSelected ? 8 : 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .blue : Color.gray.opacity(0.2))
            )
            .scaleEffect(isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25), value: isPressed)
            .gesture(DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, s, _ in s = true })
    }
}

// AnimatableModifier for custom animations
struct WobbleEffect: AnimatableModifier {
    var amount: CGFloat

    var animatableData: CGFloat {
        get { amount }
        set { amount = newValue }
    }

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(sin(amount * .pi * 4) * 3))
    }
}
""")
        }
    }
}
