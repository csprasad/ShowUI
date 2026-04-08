//
//
//  3_CustomViewModifier.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `08/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Shared custom modifiers (used in lessons 3 & 4)
struct CardModifier: ViewModifier {
    var color: Color = .vmGreen
    var radius: CGFloat = 14

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(color.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(color.opacity(0.2), lineWidth: 1))
    }
}

struct BadgeModifier: ViewModifier {
    var text: String
    var color: Color

    func body(content: Content) -> some View {
        content.overlay(alignment: .topTrailing) {
            Text(text)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 5).padding(.vertical, 2)
                .background(color)
                .clipShape(Capsule())
                .offset(x: 6, y: -6)
        }
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geo in
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .white.opacity(0.4), location: 0.4),
                        .init(color: .white.opacity(0.6), location: 0.5),
                        .init(color: .white.opacity(0.4), location: 0.6),
                        .init(color: .clear, location: 1),
                    ],
                    startPoint: .init(x: phase, y: 0),
                    endPoint: .init(x: phase + 0.5, y: 0)
                )
                .frame(width: geo.size.width * 3)
                .offset(x: geo.size.width * phase)
            }
            .clipped()
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

// MARK: - LESSON 3: Custom ViewModifier

struct CustomModifierVisual: View {
    @State private var selectedDemo = 0
    @State private var cardRadius: CGFloat = 14
    @State private var cardColor = 0
    @State private var showShimmer = false

    let demos = ["CardModifier", "BadgeModifier", "ShimmerModifier"]
    let colors: [(name: String, color: Color)] = [
        ("Green", .vmGreen), ("Blue", .navBlue), ("Purple", .ssPurple), ("Orange", .gestureOrange)
    ]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Custom ViewModifier", systemImage: "hammer.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.vmGreen)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 10, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.vmGreen : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.vmGreenLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                // Live demo
                switch selectedDemo {
                case 0:
                    // CardModifier
                    VStack(spacing: 12) {
                        // Color picker
                        HStack(spacing: 8) {
                            Text("color:").font(.system(size: 11)).foregroundStyle(.secondary)
                            ForEach(colors.indices, id: \.self) { i in
                                Button { withAnimation { cardColor = i } } label: {
                                    Circle().fill(colors[i].color).frame(width: 22, height: 22)
                                        .overlay(Circle().stroke(.white, lineWidth: cardColor == i ? 2.5 : 0))
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                            Spacer()
                        }
                        // Radius slider
                        HStack(spacing: 8) {
                            Text("radius:").font(.system(size: 11)).foregroundStyle(.secondary).frame(width: 42)
                            Slider(value: $cardRadius, in: 0...28, step: 2).tint(.vmGreen)
                            Text("\(Int(cardRadius))").font(.system(size: 11, design: .monospaced)).foregroundStyle(Color.vmGreen).frame(width: 24)
                        }
                        // Three cards with modifier applied
                        HStack(spacing: 10) {
                            ForEach(["Title", "Subtitle", "Body"], id: \.self) { label in
                                Text(label)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(colors[cardColor].color)
                                    .modifier(CardModifier(color: colors[cardColor].color, radius: cardRadius))
                            }
                        }
                        .animation(.spring(response: 0.3), value: cardColor)
                        .animation(.easeInOut(duration: 0.15), value: cardRadius)
                    }

                case 1:
                    // BadgeModifier
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 32)).foregroundStyle(Color.vmGreen)
                                .frame(width: 60, height: 60)
                                .background(Color.vmGreenLight)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .modifier(BadgeModifier(text: "3", color: .red))
                            Text(".badge(\"3\")").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            Text("Pro")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                                .modifier(BadgeModifier(text: "NEW", color: .vmGreen))
                            Text(".badge(\"NEW\")").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 28)).foregroundStyle(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.vmGreen)
                                .clipShape(Circle())
                                .modifier(BadgeModifier(text: "12", color: .animCoral))
                            Text(".badge(\"12\")").font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)

                default:
                    // ShimmerModifier
                    VStack(spacing: 12) {
                        // Shimmer on loading placeholders
                        VStack(spacing: 8) {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color(.systemFill))
                                    .frame(width: 40, height: 40)
                                    .modifier(showShimmer ? ShimmerModifier() : ShimmerModifier())
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(height: 12)
                                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(width: 120, height: 10)
                                }
                            }
                            HStack(spacing: 10) {
                                Circle().fill(Color(.systemFill)).frame(width: 40, height: 40)
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(height: 12)
                                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemFill)).frame(width: 80, height: 10)
                                }
                            }
                        }
                        .modifier(ShimmerModifier())
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)

                        Text("ShimmerModifier - sweeps a gradient across loading placeholders")
                            .font(.system(size: 10)).foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

struct CustomModifierExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Custom ViewModifier")
            Text("Conform to ViewModifier to create reusable, parameterized styling. The body(content:) function receives the view being modified as content and returns it wrapped with additional behavior or appearance.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Declare a struct conforming to ViewModifier. Add any properties needed for customization.", color: .vmGreen)
                StepRow(number: 2, text: "Implement body(content: Content) -> some View. Wrap content with your modifiers.", color: .vmGreen)
                StepRow(number: 3, text: "Apply with .modifier(MyModifier()) or define a View extension for cleaner .myModifier() syntax.", color: .vmGreen)
                StepRow(number: 4, text: "ViewModifier can hold @State - it persists as long as the modifier is applied to the view.", color: .vmGreen)
            }

            CalloutBox(style: .success, title: "Extract repeated styling", contentBody: "If you find yourself writing the same 5-modifier chain on multiple views, put it in a ViewModifier. One change to the modifier updates every place it's used - DRY principle for UI code.")

            CalloutBox(style: .info, title: "@State in ViewModifier", contentBody: "ViewModifier structs can hold @State just like Views. The state persists as long as the modifier is attached. This is how ShimmerModifier holds its animation phase - it lives inside the modifier, not the parent view.")

            CodeBlock(code: """
// Define the modifier
struct CardStyle: ViewModifier {
    var accentColor: Color = .blue
    var cornerRadius: CGFloat = 12

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(accentColor.opacity(0.08))
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(accentColor.opacity(0.2), lineWidth: 1)
            )
    }
}

// Apply it
Text("Hello")
    .modifier(CardStyle(accentColor: .purple))

// @State inside modifier
struct PulseModifier: ViewModifier {
    @State private var scale: CGFloat = 1

    func body(content: Content) -> some View {
        content.scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                    scale = 1.1
                }
            }
    }
}
""")
        }
    }
}
